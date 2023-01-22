using Random
function fit_circle(X)
    N, M = size(X)
    A = hcat(X[:,1], X[:,2], ones(N,1))
    b = -X[:,1].^2 -X[:,2].^2
    K = A\b
    d = K[1]
    e = K[2]
    f = K[3]
    return d,e,f
end

function center(d,e,f)
    x0 = -d/2
    y0 = -e/2
    r = sqrt((d/2)^2+(e/2)^2-f)
    return x0,y0,r
end

function fit_dist(X,x0,y0,r)
    N,M = size(X)
    d = zeros(N)
    for i = 1:N
        d[i] = sqrt((X[i,1] - x0)^2 + (X[i,2] - y0)^2) - r
    end
    return d
end

function RANSAC(X, num_iter, threshold)
    d = 0
    e = 0
    f = 0
    count = 0
    N,M = size(X)
    L = collect(1:N)
    for i = 1:num_iter
        L = randperm(N)
        AA=transpose(hcat(X[L[1],:], X[L[2],:], X[L[3],:]))
        d2,e2,f2 = fit_circle(AA)
        x, y, r = center(d2, e2, f2)
        distan = fit_dist(X, x,y,r)
        count1=0
        for j = 1:N
            if distan[j] < threshold && distan[j]>-threshold
                count1 = count1 +1
            end
        end
        if count1 > count
            d = d2
            e = e2
            f = f2
            count = count1
        end
    end
    x0, y0, r = center(d, e, f)
    return x0,y0,r
end

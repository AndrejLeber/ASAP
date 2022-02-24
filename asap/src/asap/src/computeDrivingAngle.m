function angle = computeDrivingAngle(currPos, aimPos, offset)

if (nargin < 3)
    offset.x = 0.0; offset.y = 0.0;
end
    dx = aimPos.position.x - currPos.position.x + offset.x;
    dy = aimPos.position.y - currPos.position.y + offset.y;
    
    angle = rad2deg(atan2(dy,dx));
end
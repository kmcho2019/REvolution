module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output reg p1y,
    output reg p2y
);

always @(*)
begin
    if (p1a && p1b && p1c && p1d)
        p1y = 1'b0;
    else
        p1y = 1'b1;

    if (p2a && p2b && p2c && p2d)
        p2y = 1'b0;
    else
        p2y = 1'b1;
end

endmodule
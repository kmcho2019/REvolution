module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*)
begin
    if (ena == 1'b1)
        q <= d;
end

endmodule
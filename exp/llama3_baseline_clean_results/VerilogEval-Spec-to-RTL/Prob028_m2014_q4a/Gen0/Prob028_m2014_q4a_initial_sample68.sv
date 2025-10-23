module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*)
begin
    if (ena)
        q <= d;
    // else q remains the same
end

endmodule
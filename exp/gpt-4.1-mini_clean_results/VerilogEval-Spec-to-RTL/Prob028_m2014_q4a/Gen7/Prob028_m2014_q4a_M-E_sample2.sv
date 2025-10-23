module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q <= d;
    else
        q <= q;  // explicit hold to clarify latch behavior for synthesis
end

endmodule
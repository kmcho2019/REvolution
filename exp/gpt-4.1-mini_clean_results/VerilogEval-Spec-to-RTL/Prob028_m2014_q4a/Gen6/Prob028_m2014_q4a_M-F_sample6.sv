module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q = d;
    // else clause omitted: q holds its value by default without needing q = q;
end

endmodule
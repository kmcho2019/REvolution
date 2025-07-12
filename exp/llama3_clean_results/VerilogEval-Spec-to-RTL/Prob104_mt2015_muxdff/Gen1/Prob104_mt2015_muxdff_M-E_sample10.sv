module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

reg internal_Q;

always @(posedge clk) begin
    if (L) begin
        Q <= q_in;
    end else begin
        internal_Q <= Q;
        Q <= internal_Q;
    end
end

endmodule
module TopModule(
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

reg q;

always @(posedge clk) begin
    if (L) begin
        q <= q_in;
    end else begin
        q <= q; // This retains the previous state
    end
end

assign Q = q;

endmodule
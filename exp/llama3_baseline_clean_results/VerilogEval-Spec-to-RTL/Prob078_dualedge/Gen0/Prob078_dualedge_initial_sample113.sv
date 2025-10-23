module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_ff; // internal flip-flop

always @(posedge clk) begin
    q_ff <= d;
    q <= q_ff;
end

always @(negedge clk) begin
    q <= d;
end

endmodule
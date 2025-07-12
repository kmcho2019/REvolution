module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    // Use the conditional operator to concisely update q based on the reset condition.
    q <= r? 1'b0 : d;
end

endmodule
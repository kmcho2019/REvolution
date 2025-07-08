module TopModule (
    input  clk,
    input  d,
    output q
);

reg q_pos, q_neg;

// Sample input on rising edge
always @(posedge clk) begin
    q_pos <= d;
end

// Sample input on falling edge
always @(negedge clk) begin
    q_neg <= d;
end

// Output logic: when clk is high, output q_pos; when low, output q_neg
assign q = clk ? q_pos : q_neg;

endmodule
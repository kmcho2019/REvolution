module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_rise, q_fall;

// Rising edge flip-flop
always @(posedge clk) begin
    q_rise <= d;
end

// Falling edge flip-flop
always @(negedge clk) begin
    q_fall <= d;
end

// Combine outputs
assign q = q_rise | q_fall;

endmodule
module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // Register to hold the previous output of the flip-flop
assign out = out_reg; // Continuous assignment to drive the output

always @(posedge clk) begin
    // The XOR gate's output is now based on the previous state of out_reg
    // This breaks the feedback loop and avoids potential race conditions
    out_reg <= in ^ out_reg;
end

endmodule
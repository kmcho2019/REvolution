module TopModule(
    input clk,
    input in,
    output reg out
);

reg out_reg; // Internal register to hold the state of the flip-flop
reg xor_result; // Temporary signal to hold the result of the XOR operation

// Always block for combinational logic (XOR operation)
always @(*) begin
    xor_result = in ^ out; // Calculate the XOR result
end

// Always block for sequential logic (D flip-flop)
always @(posedge clk) begin
    out_reg <= xor_result; // Update the internal register at the positive edge of the clock
end

assign out = out_reg; // Continuous assignment to output the current state

endmodule
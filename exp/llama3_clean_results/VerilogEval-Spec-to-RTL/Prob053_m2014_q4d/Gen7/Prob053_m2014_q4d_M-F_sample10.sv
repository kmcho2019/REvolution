module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize 'out' to 0 to avoid unknown initial value
initial begin
    out = 1'b0;
end

// D flip-flop to update the 'out' signal
always @(posedge clk) begin
    // Calculate the next state of 'out' using the XOR of 'in' and the current 'out'
    out <= in ^ out; 
end

endmodule
module TopModule(
    input clk,
    input in,
    output reg out
);

// D flip-flop to update the 'out' signal
always @(posedge clk) begin
    // Calculate the next state of 'out' using the XOR of 'in' and the current 'out'
    out <= in ^ out; 
end

endmodule
module TopModule(
    input clk,
    input in,
    output reg out
);

reg q; // Temporary signal to hold the current state of the flip-flop
initial q = 1'b0; // Initialize 'q' with a default value (0 in this case)

// Directly assign 'out' the value of 'q'
assign out = q;

// Sequential logic for D flip-flop
always @(posedge clk) begin
    q <= in ^ q; // Update q with the XOR of 'in' and the current state 'q'
end

endmodule
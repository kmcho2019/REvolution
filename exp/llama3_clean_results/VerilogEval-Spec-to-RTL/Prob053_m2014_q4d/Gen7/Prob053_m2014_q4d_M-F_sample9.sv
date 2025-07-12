module TopModule(
    input clk,
    input in,
    output reg out
);

reg q; // Temporary signal to hold the current state of the flip-flop

// Combinational logic for XOR operation
wire xor_out; // Signal to hold the output of the XOR operation
assign xor_out = in ^ q; // Calculate the XOR of 'in' and the current state 'q'

// Sequential logic for D flip-flop
always @(posedge clk) begin
    q <= xor_out; // Update q with the output of the XOR operation on the rising edge of the clock
end

// Assign 'out' the value of 'q'
always @(*) begin
    out = q; // 'out' should reflect the current state of the flip-flop
end

endmodule
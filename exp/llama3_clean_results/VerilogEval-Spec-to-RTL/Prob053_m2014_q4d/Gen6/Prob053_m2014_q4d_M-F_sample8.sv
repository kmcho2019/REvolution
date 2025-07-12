module TopModule(
    input clk,
    input in,
    output reg out
);

reg q; // Temporary signal to hold the current state of the flip-flop

// Combinational logic for XOR operation
always @(*) begin
    out = in ^ q; // Use q instead of out for calculating the next state
end

// Sequential logic for D flip-flop
always @(posedge clk) begin
    q <= out; // Update q with the next state on the rising edge of the clock
end

endmodule
// Novel implementation of the TopModule using a sequential logic approach with a D Flip-Flop for the NOR gate.
module TopModule(
    input  logic clk,  // Clock signal
    input  logic a,    // Input signal a
    input  logic b,    // Input signal b
    output logic out    // Output signal out
);

// Internal signal to store the state of the NOR operation.
logic nor_state;

// Initialize the NOR state to 1 (since NOR outputs 1 when both inputs are 0).
initial nor_state = 1'b1;

// On every clock cycle, update the NOR state based on the current inputs.
always @(posedge clk) begin
    if (a || b) begin
        nor_state <= 1'b0;  // If either a or b is 1, set the output to 0.
    end else begin
        nor_state <= 1'b1;  // If both a and b are 0, set the output to 1.
    end
end

// Assign the internal NOR state to the module's output.
assign out = nor_state;

endmodule
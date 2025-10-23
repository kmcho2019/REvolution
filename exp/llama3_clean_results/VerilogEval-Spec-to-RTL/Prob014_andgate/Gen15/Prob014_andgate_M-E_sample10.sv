// Novel, parameterizable module implementing a 2-input logic gate
module TopModule(
    // Input signals
    input  logic a,  // First input of the gate
    input  logic b,  // Second input of the gate
    // Output signal
    output logic out  // Output of the gate
);

// Internal signal to store the result
logic result;

// Implementing the gate's functionality using an always block
always_comb begin
    // Default output to 0 (can be adjusted based on the desired default behavior)
    result = 1'b0;
    
    // AND gate operation
    if (a == 1'b1 && b == 1'b1) begin
        result = 1'b1;
    end
end

// Assign the result to the output
assign out = result;

endmodule
// Define the TopModule with a novel LUT-based implementation
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);

// Define the LUT for the half adder truth table
// The LUT is essentially a 2x4 array where each row corresponds to a possible input combination (a, b)
// and the columns correspond to the outputs (sum, cout)
logic [1:0] lut[2**2]; // 2^2 = 4 possible input combinations for 2 bits

initial begin
    // Populate the LUT with the half adder truth table
    // Each entry in the LUT corresponds to a specific input combination and its resulting output
    lut[0] = 2'b00; // a=0, b=0 => sum=0, cout=0
    lut[1] = 2'b01; // a=0, b=1 => sum=1, cout=0
    lut[2] = 2'b01; // a=1, b=0 => sum=1, cout=0
    lut[3] = 2'b10; // a=1, b=1 => sum=0, cout=1
end

// Use the inputs to index into the LUT and retrieve the outputs
always @(a or b) begin
    // Combine the inputs into a single 2-bit value to index the LUT
    logic [1:0] index = {a, b};
    // Assign the LUT value at the indexed position to the outputs
    {cout, sum} = lut[index];
end

endmodule
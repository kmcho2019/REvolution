module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

// Define the lookup table for the AND gate
logic [1:0] lut_index;
logic [0:0] lut_output [3:0];

// Initialize the lookup table with the AND gate truth table
initial begin
    lut_output[0] = 1'b0; // a=0, b=0
    lut_output[1] = 1'b0; // a=0, b=1
    lut_output[2] = 1'b0; // a=1, b=0
    lut_output[3] = 1'b1; // a=1, b=1
end

// Generate the index for the lookup table based on the inputs
assign lut_index = {a, b};

// Use the lookup table to generate the output
assign q = lut_output[lut_index];

endmodule
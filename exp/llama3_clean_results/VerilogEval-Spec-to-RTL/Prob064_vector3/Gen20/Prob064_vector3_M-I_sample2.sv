// Define the TopModule with optimized structure
module TopModule(
    input  logic [4:0] a,
    input  logic [4:0] b,
    input  logic [4:0] c,
    input  logic [4:0] d,
    input  logic [4:0] e,
    input  logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);
    
    // Direct concatenation and appending of '1' bits
    logic [31:0] concatenated_appended_vector = {a, b, c, d, e, f, 2'b11};
    
    // Direct assignment of output vectors
    assign w = concatenated_appended_vector[31:24];
    assign x = concatenated_appended_vector[23:16];
    assign y = concatenated_appended_vector[15:8];
    assign z = concatenated_appended_vector[7:0];
    
endmodule
module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    wire [31:0] shifted_data;
    
    // Create initial 32-bit word with inputs and padding
    wire [31:0] initial_data = {a, b, c, d, e, f, 2'b00};
    
    // Rotate right by 2 positions to move padding to LSBs
    assign shifted_data = {initial_data[1:0], initial_data[31:2]};
    
    // Extract output vectors
    assign w = shifted_data[31:24];
    assign x = shifted_data[23:16];
    assign y = shifted_data[15:8];
    assign z = shifted_data[7:0];

endmodule
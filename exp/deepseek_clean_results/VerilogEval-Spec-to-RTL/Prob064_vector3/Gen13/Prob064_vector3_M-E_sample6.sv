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

    // Create 32-bit register with inputs and padding
    wire [31:0] full_data = {a, b, c, d, e, f, 2'b11};

    // Rotating distribution pattern
    assign w = {full_data[31], full_data[27], full_data[23], full_data[19],
                full_data[15], full_data[11], full_data[7], full_data[3]};
    
    assign x = {full_data[30], full_data[26], full_data[22], full_data[18],
                full_data[14], full_data[10], full_data[6], full_data[2]};
    
    assign y = {full_data[29], full_data[25], full_data[21], full_data[17],
                full_data[13], full_data[9], full_data[5], full_data[1]};
    
    assign z = {full_data[28], full_data[24], full_data[20], full_data[16],
                full_data[12], full_data[8], full_data[4], full_data[0]};

endmodule
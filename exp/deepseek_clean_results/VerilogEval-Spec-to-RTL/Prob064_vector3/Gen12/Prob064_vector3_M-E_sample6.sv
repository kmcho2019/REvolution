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

    // Create full 32-bit internal representation
    wire [31:0] full_word;
    
    // Assign inputs to upper 30 bits and padding to lower 2 bits
    assign full_word[31:2] = {a, b, c, d, e, f};
    assign full_word[1:0] = 2'b11;
    
    // Explicitly select 8-bit chunks for each output
    assign w = full_word[31:24];
    assign x = full_word[23:16];
    assign y = full_word[15:8];
    assign z = full_word[7:0];

endmodule
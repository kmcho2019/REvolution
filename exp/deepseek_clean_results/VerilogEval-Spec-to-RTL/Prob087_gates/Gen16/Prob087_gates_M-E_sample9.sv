module TopModule (
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // Operation matrix - stores all possible output combinations
    reg [6:0] op_matrix [0:3];
    
    // Initialize the operation matrix with truth tables
    initial begin
        // Index: {b,a}
        // Output order: [and, or, xor, nand, nor, xnor, anotb]
        op_matrix[2'b00] = 7'b0001010; // a=0, b=0
        op_matrix[2'b01] = 7'b0110100; // a=1, b=0
        op_matrix[2'b10] = 7'b0011111; // a=0, b=1
        op_matrix[2'b11] = 7'b1100010; // a=1, b=1
    end

    // Select outputs based on input combination
    wire [6:0] outputs = op_matrix[{b,a}];
    
    // Assign individual outputs
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = outputs;

endmodule
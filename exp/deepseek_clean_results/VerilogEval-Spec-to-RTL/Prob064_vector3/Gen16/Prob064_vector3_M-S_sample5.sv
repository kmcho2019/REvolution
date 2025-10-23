module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    // Concatenate all inputs and pad with 2'b11 at LSBs
    wire [31:0] combined = {a, b, c, d, e, f, 2'b11};
    
    // Split into 8-bit outputs
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule
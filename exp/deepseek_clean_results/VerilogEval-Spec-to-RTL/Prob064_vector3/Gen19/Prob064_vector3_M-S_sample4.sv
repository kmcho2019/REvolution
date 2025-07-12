module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    wire [29:0] combined = {a, b, c, d, e, f};
    
    assign w = combined[29:22];
    assign x = combined[21:14];
    assign y = combined[13:6];
    assign z = {combined[5:0], 2'b11};

endmodule
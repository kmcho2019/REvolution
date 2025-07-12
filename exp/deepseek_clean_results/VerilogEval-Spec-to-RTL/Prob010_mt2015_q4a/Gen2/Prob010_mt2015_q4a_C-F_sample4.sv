module TopModule (
    input x,
    input y,
    output z
);
    wire x_xor_y;
    wire xor_and_x;
    
    assign x_xor_y = x ^ y;
    assign xor_and_x = x_xor_y & x;
    assign z = xor_and_x;
endmodule
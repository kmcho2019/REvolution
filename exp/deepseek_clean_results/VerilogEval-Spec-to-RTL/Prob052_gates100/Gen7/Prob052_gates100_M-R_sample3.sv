module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND/OR using reduction operators (alternative syntax)
    assign out_and = &in[99:0];
    assign out_or = |in[99:0];

    // XOR using explicit tree structure (5 levels of 20 bits)
    wire [19:0] xor_l1 = {
        ^in[99:80], ^in[79:60], ^in[59:40], ^in[39:20], ^in[19:0]
    };
    
    wire [3:0] xor_l2 = {
        ^xor_l1[19:15], ^xor_l1[14:10], ^xor_l1[9:5], ^xor_l1[4:0]
    };
    
    assign out_xor = ^xor_l2;

endmodule
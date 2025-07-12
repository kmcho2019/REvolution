module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shared expressions for adjacent bits
    wire [2:0] adjacent_bits = in[2:0] & in[3:1];
    wire [2:0] any_bits = in[3:1] | in[2:0];
    
    assign out_both = {1'b0, adjacent_bits};  // out_both[3] is don't care
    assign out_any = {any_bits, 1'b0};        // out_any[0] is don't care
    
    // Efficient circular XOR using shift and XOR
    assign out_different = in ^ {in[0], in[3:1]};

endmodule
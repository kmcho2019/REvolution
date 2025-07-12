// Reconfigurable XOR gate module
module reconfig_xor(
    input  clk,
    input  [1:0] mode,  // 2-bit mode selection: 00 - continuous assignment, 01 - combinational always block, 10 - clocked always block
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Continuous assignment implementation
    assign out_assign = a ^ b;

    // Combinational always block implementation
    reg out_always_comb_reg;
    always_comb begin
        out_always_comb_reg = a ^ b;
    end
    assign out_always_comb = out_always_comb_reg;

    // Clocked always block implementation
    reg out_always_ff_reg;
    always_ff @(posedge clk) begin
        out_always_ff_reg <= a ^ b;
    end
    assign out_always_ff = out_always_ff_reg;

endmodule

// TopModule instantiating the reconfigurable XOR gate module
module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    reconfig_xor u_xor(
       .clk(clk),
       .mode(2'b10),  // Select clocked always block mode
       .a(a),
       .b(b),
       .out_assign(out_assign),
       .out_always_comb(out_always_comb),
       .out_always_ff(out_always_ff)
    );
endmodule
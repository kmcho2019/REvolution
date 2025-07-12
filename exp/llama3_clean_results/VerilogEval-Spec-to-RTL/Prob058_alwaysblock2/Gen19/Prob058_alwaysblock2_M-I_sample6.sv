// Sub-module for continuous assignment
module xor_assign(
    input  a,
    input  b,
    output out_assign
);
    assign out_assign = a ^ b;
endmodule

// Sub-module for combinational always block
module xor_always_comb(
    input  a,
    input  b,
    output reg out_always_comb
);
    always_comb begin
        out_always_comb = a ^ b;
    end
endmodule

// Sub-module for clocked always block
module xor_always_ff(
    input  clk,
    input  a,
    input  b,
    output reg out_always_ff
);
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
endmodule

// TopModule instantiating sub-modules
module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    xor_assign u_assign(
       .a(a),
       .b(b),
       .out_assign(out_assign)
    );

    xor_always_comb u_always_comb(
       .a(a),
       .b(b),
       .out_always_comb(out_always_comb)
    );

    xor_always_ff u_always_ff(
       .clk(clk),
       .a(a),
       .b(b),
       .out_always_ff(out_always_ff)
    );
endmodule
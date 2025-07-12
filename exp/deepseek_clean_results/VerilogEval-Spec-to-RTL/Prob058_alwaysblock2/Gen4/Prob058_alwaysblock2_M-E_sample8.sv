module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Instantiate assign-style XOR module
    xor_assign assign_inst (
        .a(a),
        .b(b),
        .out(out_assign)
    );

    // Instantiate combinational always-style XOR module
    xor_always_comb comb_inst (
        .a(a),
        .b(b),
        .out(out_always_comb)
    );

    // Instantiate sequential always-style XOR module
    xor_always_ff seq_inst (
        .clk(clk),
        .a(a),
        .b(b),
        .out(out_always_ff)
    );

endmodule

// Submodule implementing XOR with continuous assignment
module xor_assign (
    input a,
    input b,
    output out
);
    assign out = a ^ b;
endmodule

// Submodule implementing XOR with combinational always block
module xor_always_comb (
    input a,
    input b,
    output reg out
);
    always_comb begin
        out = a ^ b;
    end
endmodule

// Submodule implementing XOR with sequential always block
module xor_always_ff (
    input clk,
    input a,
    input b,
    output reg out
);
    always_ff @(posedge clk) begin
        out <= a ^ b;
    end
endmodule
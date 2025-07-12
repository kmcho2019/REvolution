// Define a separate module for the XOR gate
module xor_gate(
    input a,
    input b,
    output out
);
    assign out = a ^ b;
endmodule

// Sub-module for both continuous assignment and combinational always block
module xor_assign_and_always_comb(
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb
);
    wire internal_xor;
    xor_gate u_xor(
        .a(a),
        .b(b),
        .out(internal_xor)
    );
    assign out_assign = internal_xor;
    always_comb begin
        out_always_comb = internal_xor;
    end
endmodule

// Sub-module for clocked always block with clock gating
module xor_always_ff(
    input  clk,
    input  clk_enable, // New input for clock gating
    input  a,
    input  b,
    output reg out_always_ff
);
    wire internal_xor;
    xor_gate u_xor(
        .a(a),
        .b(b),
        .out(internal_xor)
    );
    always_ff @(posedge clk) begin
        if (clk_enable) begin
            out_always_ff <= internal_xor;
        end
    end
endmodule

// TopModule instantiating sub-modules with optimization
module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    xor_assign_and_always_comb u_assign_and_always_comb(
        .a(a),
        .b(b),
        .out_assign(out_assign),
        .out_always_comb(out_always_comb)
    );

    xor_always_ff u_always_ff(
        .clk(clk),
        .clk_enable(1'b1), // Always enable the clock for this example
        .a(a),
        .b(b),
        .out_always_ff(out_always_ff)
    );
endmodule
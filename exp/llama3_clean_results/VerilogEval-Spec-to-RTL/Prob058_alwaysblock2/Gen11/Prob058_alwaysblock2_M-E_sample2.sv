// Shared sub-module for combinational logic
module xor_comb(
    input  a,
    input  b,
    output out_comb
);
    assign out_comb = a ^ b;
endmodule

// TopModule using shared sub-module
module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    // Continuous assignment using shared sub-module
    xor_comb u_assign(
       .a(a),
       .b(b),
       .out_comb(out_assign)
    );

    // Combinational always block using shared sub-module
    reg comb_out;
    xor_comb u_always_comb(
       .a(a),
       .b(b),
       .out_comb(comb_out)
    );
    always_comb begin
        out_always_comb = comb_out;
    end

    // Clocked always block
    always_ff @(posedge clk) begin
        out_always_ff <= comb_out;
    end
endmodule
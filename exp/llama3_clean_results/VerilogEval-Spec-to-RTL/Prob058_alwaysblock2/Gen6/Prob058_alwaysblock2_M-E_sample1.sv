// Parameterized sub-module for XOR operation
module xor_param(
    input  clk,
    input  mode, // 0: continuous, 1: combinational, 2: clocked
    input  a,
    input  b,
    output reg out
);
    always @(a or b or mode) begin
        case (mode)
            0: out = a ^ b; // continuous
            1: out = a ^ b; // combinational
            2: begin
                reg tmp;
                always_ff @(posedge clk) begin
                    tmp <= a ^ b;
                end
                out = tmp;
            end
            default: out = 1'b0; // default output
        endcase
    end
endmodule

// TopModule instantiating sub-modules
module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    xor_param u_assign(
       .clk(1'b0), // unused
       .mode(0), // continuous
       .a(a),
       .b(b),
       .out(out_assign)
    );

    xor_param u_always_comb(
       .clk(1'b0), // unused
       .mode(1), // combinational
       .a(a),
       .b(b),
       .out(out_always_comb)
    );

    xor_param u_always_ff(
       .clk(clk),
       .mode(2), // clocked
       .a(a),
       .b(b),
       .out(out_always_ff)
    );
endmodule
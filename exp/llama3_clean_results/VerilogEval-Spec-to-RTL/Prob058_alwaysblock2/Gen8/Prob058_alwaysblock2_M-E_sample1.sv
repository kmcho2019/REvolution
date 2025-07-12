// Parameterizable XOR module
module param_xor(
    input  clk,
    input  a,
    input  b,
    output reg out,
    parameter mode = "comb"  // Can be "comb" or "seq"
);

    if (mode == "comb") begin
        always_comb begin
            out = a ^ b;
        end
    end else if (mode == "seq") begin
        always_ff @(posedge clk) begin
            out <= a ^ b;
        end
    end else begin
        $display("Invalid mode. Please use 'comb' or 'seq'.");
        $finish;
    end

endmodule

// TopModule instantiating param_xor with different modes
module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    param_xor u_assign(
       .clk(clk),
       .a(a),
       .b(b),
       .out(out_assign),
       .mode("comb")
    );

    param_xor u_always_comb(
       .clk(clk),
       .a(a),
       .b(b),
       .out(out_always_comb),
       .mode("comb")
    );

    param_xor u_always_ff(
       .clk(clk),
       .a(a),
       .b(b),
       .out(out_always_ff),
       .mode("seq")
    );
endmodule
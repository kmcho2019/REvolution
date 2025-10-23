module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment - single XOR implementation
    assign out_assign = a ^ b;

    // Combinational always block - reuse assign output
    always_comb begin
        out_always_comb = out_assign;
    end

    // Sequential always block - independent implementation
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
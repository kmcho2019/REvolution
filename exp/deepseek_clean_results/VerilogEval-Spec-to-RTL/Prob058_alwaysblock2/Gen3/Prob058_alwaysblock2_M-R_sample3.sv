module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment for combinational logic
    assign out_assign = a ^ b;
    
    // Direct assignment for combinational output
    assign out_always_comb = a ^ b;

    // Sequential always block with flip-flop
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
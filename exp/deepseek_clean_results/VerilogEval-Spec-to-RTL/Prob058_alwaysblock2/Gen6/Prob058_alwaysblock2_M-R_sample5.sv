module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Continuous assignment for combinational logic
    assign out_assign = a ^ b;
    
    // Alternative continuous assignment for combinational logic
    assign out_always_comb = a ^ b;

    // Sequential implementation with flip-flop
    reg out_ff;
    always_ff @(posedge clk) begin
        out_ff <= a ^ b;
    end
    
    assign out_always_ff = out_ff;

endmodule
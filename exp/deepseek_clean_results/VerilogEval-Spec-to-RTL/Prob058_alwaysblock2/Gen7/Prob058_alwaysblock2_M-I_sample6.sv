module TopModule (
    input clk,
    input a,
    input b,
    output wire out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Shared XOR result for combinational paths
    wire comb_xor = a ^ b;
    
    // Continuous assignment using shared result
    assign out_assign = comb_xor;
    
    // Combinational always block using shared result
    always @(*) begin
        out_always_comb = comb_xor;
    end
    
    // Sequential always block remains separate
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
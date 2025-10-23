module TopModule (
    input  clk,
    input  a,
    input  b,
    output wire xor_assign,
    output reg  xor_always_comb,
    output reg  xor_always_ff
);

    // Continuous assignment
    assign xor_assign = a ^ b;
    
    // Combinational always block
    always @(*) begin
        xor_always_comb = a ^ b;
    end
    
    // Sequential always block
    always @(posedge clk) begin
        xor_always_ff <= a ^ b;
    end

endmodule
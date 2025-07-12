module TopModule (
    input clk,
    input a,
    input b,
    output wire out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Single shared XOR result for all outputs
    wire shared_xor = a ^ b;
    
    // Continuous assignment
    assign out_assign = shared_xor;
    
    // Combinational always block
    always @(*) begin
        out_always_comb = shared_xor;
    end
    
    // Sequential always block using the same XOR result
    always @(posedge clk) begin
        out_always_ff <= shared_xor;
    end

endmodule
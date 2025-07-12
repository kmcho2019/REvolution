module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    wire xor_result = a ^ b;
    
    // Continuous assignment
    assign out_assign = xor_result;
    
    // Combinational always block
    always @(*) begin
        out_always_comb = xor_result;
    end
    
    // Sequential always block
    always @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule
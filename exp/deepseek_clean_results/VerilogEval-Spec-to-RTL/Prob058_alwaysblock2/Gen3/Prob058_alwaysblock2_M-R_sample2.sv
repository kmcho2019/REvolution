module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Shared XOR result for combinational outputs
    wire xor_result = a ^ b;
    
    // Continuous assignment
    assign out_assign = xor_result;
    
    // Combinational always block
    assign out_always_comb = xor_result;
    
    // Sequential implementation
    always @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule
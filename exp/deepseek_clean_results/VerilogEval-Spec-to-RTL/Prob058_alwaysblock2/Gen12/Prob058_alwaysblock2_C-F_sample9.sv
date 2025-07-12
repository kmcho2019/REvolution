module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    wire xor_result = a ^ b;

    assign out_assign = xor_result;
    
    always @(*) out_always_comb = xor_result;
    
    always @(posedge clk) out_always_ff <= xor_result;

endmodule
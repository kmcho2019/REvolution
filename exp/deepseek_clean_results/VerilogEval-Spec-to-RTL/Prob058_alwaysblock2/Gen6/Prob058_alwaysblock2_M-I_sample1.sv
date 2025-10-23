module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Single XOR implementation shared by combinational outputs
    wire xor_result = a ^ b;
    
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;

    // Sequential implementation (required)
    always @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule
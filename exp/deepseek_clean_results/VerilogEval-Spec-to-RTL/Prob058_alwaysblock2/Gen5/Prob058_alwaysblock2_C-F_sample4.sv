module TopModule #(
    parameter INCLUDE_SEQ = 1  // 1 to include sequential implementation, 0 for combinational only
)(
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff = 1'b0  // Initialize to avoid X propagation
);

    // Shared XOR operation for combinational outputs
    wire xor_result = a ^ b;
    
    // Combinational outputs
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;

    // Conditional sequential implementation
    generate if (INCLUDE_SEQ) begin
        always @(posedge clk) begin
            out_always_ff <= xor_result;
        end
    end
    endgenerate

endmodule
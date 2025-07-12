module TopModule #(
    parameter INCLUDE_SEQUENTIAL = 1  // 1 to include sequential implementation
)(
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Shared XOR operation for combinational outputs
    wire xor_result = a ^ b;
    
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;

    // Conditional sequential implementation
    generate if (INCLUDE_SEQUENTIAL) begin
        always @(posedge clk) begin
            out_always_ff <= xor_result;
        end
    end
    else begin
        initial out_always_ff = 1'b0;
    end
    endgenerate

endmodule
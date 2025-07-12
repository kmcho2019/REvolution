module TopModule #(
    parameter INCLUDE_SEQ = 1  // Set to 0 to exclude sequential implementation
)(
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Single XOR operation shared by combinational outputs
    wire xor_result = a ^ b;
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;

    // Conditional sequential implementation
    generate if (INCLUDE_SEQ) begin
        always @(posedge clk) begin
            out_always_ff <= xor_result;  // Uses same XOR but registered
        end
    end
    else begin
        initial out_always_ff = 1'b0;
    end
    endgenerate

endmodule
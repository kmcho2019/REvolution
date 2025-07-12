module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,  // Changed to wire
    output reg  out_always_ff
);

    // Shared XOR computation wire
    wire xor_result;
    assign xor_result = a ^ b;

    // Continuous assignment implementation (unchanged)
    assign out_assign = xor_result;

    // Alternative combinational implementation using assign
    assign out_always_comb = xor_result;

    // Sequential implementation with explicit intermediate wire
    always @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule
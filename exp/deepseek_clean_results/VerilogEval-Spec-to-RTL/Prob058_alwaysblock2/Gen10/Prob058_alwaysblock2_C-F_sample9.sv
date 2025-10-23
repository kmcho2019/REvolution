module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Shared XOR computation for all outputs
    wire xor_result = a ^ b;

    // Continuous assignment (most efficient implementation)
    assign out_assign = xor_result;

    // Combinational always block
    always @(*) begin
        out_always_comb = xor_result;
    end

    // Sequential always block (registered output)
    always @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule
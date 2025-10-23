module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Shared XOR result for all implementations
    wire xor_result = a ^ b;

    // Continuous assignment implementation
    assign out_assign = xor_result;

    // Combinational always block implementation
    always_comb begin
        out_always_comb = xor_result;
    end

    // Sequential always block implementation
    always_ff @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule
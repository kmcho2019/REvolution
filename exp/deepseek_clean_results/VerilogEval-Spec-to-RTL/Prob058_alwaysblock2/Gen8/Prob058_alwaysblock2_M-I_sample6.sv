module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    parameter ENABLE_SEQ = 1;  // Enable for sequential output (power control)
    wire xor_result = a ^ b;   // Shared XOR computation

    // Continuous assignment - combinational logic
    assign out_assign = xor_result;

    // Combinational always block
    always_comb begin
        out_always_comb = xor_result;
    end

    // Sequential always block with enable
    always_ff @(posedge clk) begin
        if (ENABLE_SEQ) begin
            out_always_ff <= xor_result;
        end
    end

endmodule
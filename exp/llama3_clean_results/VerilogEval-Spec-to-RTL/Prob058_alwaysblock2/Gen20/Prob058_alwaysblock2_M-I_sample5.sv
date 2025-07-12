// TopModule implementation with optimized PPA metrics
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Directly implement XOR logic within TopModule for out_assign
    assign out_assign = a ^ b;

    // Use always_comb for out_always_comb to ensure combinational logic
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Maintain non-blocking assignment for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
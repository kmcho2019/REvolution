module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Directly implement XOR for out_assign
    assign out_assign = a ^ b;

    // Use always_comb for out_always_comb
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Clocked always block for out_always_ff
    always @(posedge clk) begin
        out_always_ff = a ^ b;
    end

endmodule
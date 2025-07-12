module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Internal wire holding XOR of a and b, shared for logic reuse
    wire xor_val = a ^ b;

    // Continuous assignment for combinational output
    assign out_assign = xor_val;

    // Combinational always block using blocking assignment
    always @(*) begin
        out_always_comb = xor_val;
    end

    // Sequential always block with non-blocking assignment to register xor_val
    always @(posedge clk) begin
        out_always_ff <= xor_val;
    end

endmodule
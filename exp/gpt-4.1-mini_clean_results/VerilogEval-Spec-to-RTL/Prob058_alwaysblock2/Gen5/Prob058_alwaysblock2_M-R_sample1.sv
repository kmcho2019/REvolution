module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Direct assign of XOR expression
    assign out_assign = a ^ b;

    // Combinational always block computes XOR directly
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential always block registers the combinational output
    always @(posedge clk) begin
        out_always_ff <= out_always_comb;
    end

endmodule
module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Shared XOR wire to reduce duplicated logic for combinational outputs
    wire xor_out = a ^ b;

    // Continuous assignment driven by shared wire
    assign out_assign = xor_out;

    // Combinational always block uses the shared wire
    always @(*) begin
        out_always_comb = xor_out;
    end

    // Sequential always block registers the XOR expression directly
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
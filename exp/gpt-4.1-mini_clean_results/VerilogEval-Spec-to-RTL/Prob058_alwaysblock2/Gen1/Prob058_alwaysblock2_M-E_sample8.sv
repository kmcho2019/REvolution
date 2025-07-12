module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Instantiate XOR gate primitive for out_assign
    xor u_xor_assign(out_assign, a, b);

    reg comb_result;

    // Combinational always block using casez for XOR logic
    always @(*) begin
        casez({a,b})
            2'b00: comb_result = 0;
            2'b01: comb_result = 1;
            2'b10: comb_result = 1;
            2'b11: comb_result = 0;
            default: comb_result = 0; // Should never occur
        endcase
        out_always_comb = comb_result;
    end

    // Sequential logic with intermediate register pipeline stage
    reg intermediate;

    always @(posedge clk) begin
        intermediate <= a ^ b;
        out_always_ff <= intermediate;
    end

endmodule
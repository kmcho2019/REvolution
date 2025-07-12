module TopModule #(
    parameter DELAY_CYCLES = 1
) (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output wire out_always_ff
);

    // LUT-based XOR implementation (4-entry truth table)
    wire [3:0] xor_lut = {1'b0, 1'b1, 1'b1, 1'b0};
    wire [1:0] lut_addr = {a, b};
    
    // Clock gating logic (power saving)
    wire inputs_changed = (a != $past(a)) || (b != $past(b));
    wire gated_clk = clk & inputs_changed;
    
    // Combinational outputs
    assign out_assign = xor_lut[lut_addr];
    assign out_always_comb = a ? ~b : b;
    
    // Sequential output with configurable delay
    reg [DELAY_CYCLES-1:0] ff_chain;
    always @(posedge gated_clk) begin
        ff_chain <= {ff_chain[DELAY_CYCLES-2:0], a ^ b};
    end
    assign out_always_ff = ff_chain[DELAY_CYCLES-1];

    // Past value tracking for clock gating
    reg past_a, past_b;
    always @(posedge clk) begin
        past_a <= a;
        past_b <= b;
    end

endmodule
// Option 1: Original combinational code (already optimal for zero latency)
module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    assign out = { {24{in[7]}}, in };
endmodule

// Option 2: Registered sign bit to reduce fanout and improve power/timing with 1 cycle latency
// Uncomment and use this version if a clock is available and one cycle latency is acceptable.
/*
module TopModule(
    input             clk,
    input      [7:0]  in,
    output reg [31:0] out
);
    reg sign_bit_reg;

    always @(posedge clk) begin
        sign_bit_reg <= in[7];
    end

    always @(posedge clk) begin
        out <= { {24{sign_bit_reg}}, in };
    end
endmodule
*/
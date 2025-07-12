module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_q;

// When a=1, next_q is 4.
// When a=0, next_q = (q+1) mod 7 cycling through 4..6,0..3 as in waveform.
wire [3:0] q_plus1_mod7 = (q == 3'd6) ? 3'd0 :
                         (q == 3'd3) ? 3'd4 :
                         (q + 1);

// But above expression is complicated; better to implement modulo 7 counter with base 4 offset:
// The cycle: 4,5,6,0,1,2,3,4,...
// Map q to modulo 7 value as: q_mod7 = (q >= 4) ? q - 4 : q + 3;
// Then next = (q_mod7 + 1) % 7;
// Then convert back: q_next = (next < 3) ? next + 4 : next - 3;

// Implementing this logic combinationally:

wire [2:0] q_mod7 = (q >= 3'd4) ? (q - 3'd4) : (q + 3'd3);
wire [2:0] next_mod7 = (q_mod7 == 3'd6) ? 3'd0 : q_mod7 + 3'd1;
wire [2:0] next_q_calc = (next_mod7 < 3'd3) ? (next_mod7 + 3'd4) : (next_mod7 - 3'd3);

assign next_q = a ? 3'd4 : next_q_calc;

always @(posedge clk) begin
    if (q !== next_q) // update q only if changed to reduce toggling
        q <= next_q;
end

endmodule
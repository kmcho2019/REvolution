module TopModule (
    input        clk,
    input        a,
    output reg [2:0] q
);

wire [2:0] next_q_arith;
wire [2:0] next_q_comb;

// Calculate next state when a=0 as modulo-7 count in sequence 4→5→6→0→1→2→3→4...
// Map current q to 0..6 range: q_offset = (q + 3) % 7
// Then increment modulo 7: q_offset_next = (q_offset + 1) % 7
// Map back: next_q = (q_offset_next + 4) % 7
// This cycle matches the sequence in the waveform.
// To simplify modulo 7 increment, use arithmetic with wrap-around.

// Compute offset: add 3 and modulo 7
function [2:0] mod7_add;
    input [2:0] in_val;
    input [2:0] add_val;
    reg [3:0] sum;
    begin
        sum = in_val + add_val;
        if (sum >= 7)
            mod7_add = sum - 7;
        else
            mod7_add = sum[2:0];
    end
endfunction

wire [2:0] q_offset = mod7_add(q, 3'd3);
wire [2:0] q_offset_next = mod7_add(q_offset, 3'd1);
wire [2:0] q_next = mod7_add(q_offset_next, 3'd4);

assign next_q_comb = a ? 3'd4 : q_next;

always @(posedge clk) begin
    q <= next_q_comb;
end

endmodule
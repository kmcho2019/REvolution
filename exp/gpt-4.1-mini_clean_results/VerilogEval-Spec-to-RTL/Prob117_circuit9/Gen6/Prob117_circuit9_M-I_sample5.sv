module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

// Calculate next_q with arithmetic modulo-7 increment starting at 4 when a=0
// If a=1, q is forced to 4

wire [3:0] q_plus_3 = q + 3; // q_minus_4 modulo 7 shifted
wire [3:0] q_plus_3_plus1 = q_plus_3 + 1;

// modulo 7 wrap for q_plus_3_plus1
wire [2:0] mod7_inc = (q_plus_3_plus1 >= 7) ? (q_plus_3_plus1 - 7) : q_plus_3_plus1;

// next_q = (mod7_inc + 4) modulo 7, but since mod7_inc < 7 and 4 < 7, sum can be up to 10
wire [3:0] sum = mod7_inc + 4;
wire [2:0] next_count = (sum >= 7) ? (sum - 7) : sum;

always @(*) begin
    if (a)
        next_q = 3'd4;
    else
        next_q = next_count;
end

always @(posedge clk) begin
    if (q !== next_q) // avoid unnecessary toggling to save power
        q <= next_q;
end

endmodule
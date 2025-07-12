module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] q_next_mod7;
wire [2:0] next_q;

// Calculate next state in modulo-7 cycle (0..6) when a=0
assign q_next_mod7 = (q == 3'd6) ? 3'd0 : (q + 3'd1);

// Select next state based on 'a'
assign next_q = a ? 3'd4 : ( 
    // When 'a' is 0 and q is outside 0..6, reset to 4 to match behavior
    (q <= 3'd6) ? q_next_mod7 : 3'd4 
);

always @(posedge clk) begin
    q <= next_q;
end

endmodule
module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] q_next;
wire [3:0] inc_q;  // 4 bits to hold q+1 before modulo reduction

// Increment q by 1
assign inc_q = q + 3'd1;

// Modulo 7: if inc_q == 7, wrap to 0; else inc_q[2:0]
assign q_next = (inc_q == 4'd7) ? 3'd0 : inc_q[2:0];

// On clock edge, load 4 if a=1, else next incremented state
always @(posedge clk) begin
    if (a)
        q <= 3'd4;
    else
        q <= q_next;
end

endmodule
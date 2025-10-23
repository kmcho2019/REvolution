module TopModule (
    input        clk,
    input        reset,
    output reg [3:0] q
);

wire [3:0] next_q;
wire roll_over;

// Detect if current count is 9
assign roll_over = (q == 4'd9);

// Compute next_q: if roll_over, next_q = 0; else q + 1
assign next_q = roll_over ? 4'd0 : (q + 4'd1);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= next_q;
end

endmodule
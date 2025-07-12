module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;
wire q_change;

// Compute next state using arithmetic for modulo-7 counting when a=0, else hold at 4
always @(*) begin
    if (a) begin
        next_q = 3'd4; // Hold at 4 when a=1
    end else begin
        // Increment modulo 7 (0 to 6)
        next_q = (q == 3'd6) ? 3'd0 : (q + 3'd1);
    end
end

// Determine if q will change; if not, avoid updating q register to save power
assign q_change = (next_q != q);

always @(posedge clk) begin
    if (q_change) begin
        q <= next_q;
    end
end

endmodule
module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [3:0] q_int;  // 4 bits internally for modulo-7 counting (0-6)

// Compute next state combinationally
wire [3:0] next_q_int;

assign next_q_int = (a) ? 4'd4 : ((q_int == 4'd6) ? 4'd0 : q_int + 4'd1);

always @(posedge clk) begin
    q_int <= next_q_int;
end

// Output q is lower 3 bits of internal state (safe since q_int max is 6 or 4)
always @(*) begin
    q = q_int[2:0];
end

endmodule
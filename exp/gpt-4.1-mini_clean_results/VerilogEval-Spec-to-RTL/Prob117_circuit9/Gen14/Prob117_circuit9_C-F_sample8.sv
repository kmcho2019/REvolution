module TopModule (
    input        clk,
    input        a,
    output reg [2:0] q
);

// Define the next state as increment mod 7 (states 0 to 6), preset to 4 when 'a' is high
wire [2:0] next_q = a ? 3'd4 : ((q == 3'd6) ? 3'd0 : (q + 3'd1));

// Optional asynchronous reset to 4 on startup to avoid unknown initial state
// If asynchronous reset is not desired, q can start as unknown or initialized elsewhere
// Here we assume power-up reset to 4
initial q = 3'd4;

always @(posedge clk) begin
    q <= next_q;
end

endmodule
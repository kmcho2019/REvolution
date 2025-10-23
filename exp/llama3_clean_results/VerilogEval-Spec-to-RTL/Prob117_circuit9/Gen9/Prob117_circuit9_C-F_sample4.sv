module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Internal signal to hold the next state
reg [2:0] next_q;

// Combinational logic to determine the next state
always @(*) begin
    if (a) begin
        // Reset 'q' to 4 when 'a' is high
        next_q = 4;
    end else begin
        // If 'q' is 6, wrap around to 0; otherwise, increment 'q'
        next_q = (q == 6) ? 0 : q + 1;
    end
end

// Sequential logic to update 'q' at each positive clock edge
always @(posedge clk) begin
    q <= next_q;
end

// Initialize 'q' to 4 at the start
initial q = 4;

endmodule
module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Simplified next state logic
reg [2:0] next_q;

always @(*) begin
    if (a) begin
        next_q = 4; // Direct assignment when 'a' is high
    end else begin
        // Increment current state unless it's 6, then wrap around
        next_q = (q == 6) ? 0 : q + 1;
    end
end

// Update current state at positive edge of the clock
always @(posedge clk) begin
    q <= next_q;
end

// Initialize the output
initial q = 4;

endmodule
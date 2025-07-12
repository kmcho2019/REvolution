module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize the output
initial q = 4;

// Define the next state calculation
reg [2:0] next_q;

always @(*) begin
    if (a) begin
        next_q = 4; // Reset to 4 when a is high
    end else if (q < 6) begin
        next_q = q + 1; // Increment q when a is low and q < 6
    end else begin
        next_q = 0; // Wrap around to 0 when q reaches 6
    end
end

// Define the sequential logic
always @(posedge clk) begin
    q <= next_q;
end

endmodule
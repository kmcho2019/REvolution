module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize the output
initial q = 4;

// Define the sequential logic
always @(posedge clk) begin
    if (a) begin
        q <= 4; // Reset to 4 when a is high
    end else if (q == 6) begin
        q <= 0; // Wrap around to 0 when q reaches 6
    end else begin
        q <= q + 1; // Increment q when a is low and q < 6
    end
end

endmodule
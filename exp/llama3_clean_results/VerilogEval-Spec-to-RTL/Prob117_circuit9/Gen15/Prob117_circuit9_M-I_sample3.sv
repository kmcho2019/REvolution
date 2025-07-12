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
        // Reset to 4 when a is high, minimizing switching activity
        q <= 4;
    end else if (q == 6) begin
        // Wrap around to 0 when q reaches 6, reducing the need for complex logic
        q <= 0;
    end else begin
        // Increment q when a is low and q < 6, using a simple and efficient operation
        q <= q + 1;
    end
end

endmodule
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
        // Direct reset to 4 when 'a' is high
        q <= 4;
    end else begin
        // Increment 'q' when 'a' is low
        if (q == 6) begin
            // Wrap around to 0 when 'q' reaches 6
            q <= 0;
        end else begin
            // Increment 'q' by 1
            q <= q + 1;
        end
    end
end

endmodule
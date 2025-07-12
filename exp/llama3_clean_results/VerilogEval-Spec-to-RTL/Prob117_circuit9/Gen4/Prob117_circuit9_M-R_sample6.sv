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
        // Reset to 4 when a is high
        q <= 3'b100;
    end else begin
        // Increment q when a is low, wrapping around from 6 to 0
        if (q == 6) begin
            q <= 0;
        end else begin
            q <= q + 1;
        end
    end
end

endmodule
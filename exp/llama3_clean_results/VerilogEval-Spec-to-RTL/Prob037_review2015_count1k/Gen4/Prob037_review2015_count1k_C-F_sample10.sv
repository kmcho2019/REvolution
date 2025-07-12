module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

// Define a parameter for the maximum count value
parameter MAX_COUNT = 10'd999;

reg [9:0] count;

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0
        count <= 10'd0;
    end else if (count == MAX_COUNT) begin
        // Reset count to 0 when it reaches the maximum value
        count <= 10'd0;
    end else begin
        // Increment the counter
        count <= count + 1;
    end
end

assign q = count;

endmodule
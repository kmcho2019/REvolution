module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

// Sequential logic to update the counter
always @(posedge clk) begin
    if (reset) begin
        // Reset to 1, maintaining the required initial state
        count <= 4'd1;
    end else if (count == 4'd10) begin
        // Wrap around to 1, ensuring the counter operates as intended
        count <= 4'd1;
    end else begin
        // Simple increment operation, which is efficient for a small counter
        count <= count + 1;
    end
end

// Straightforward output assignment to minimize area and power overhead
assign q = count;

endmodule
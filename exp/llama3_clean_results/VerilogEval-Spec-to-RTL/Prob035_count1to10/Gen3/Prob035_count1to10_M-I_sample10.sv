module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count = 4'b0001; // Initialize count to 1

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 1
        count <= 4'b0001;
    end else begin
        // If count is at its maximum (10), wrap around to 1; otherwise, increment
        if (count == 4'b1010) begin
            count <= 4'b0001; // Wrap around to 1
        end else begin
            count <= count + 1; // Increment count
        end
    end
end

// Direct assignment of count to output
assign q = count;

endmodule
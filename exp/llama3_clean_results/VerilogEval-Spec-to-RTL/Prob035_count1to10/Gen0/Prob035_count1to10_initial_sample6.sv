module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0001; // Reset to 1 (binary 0001)
    end else if (count == 4'b1010) begin // Count reached 10 (binary 1010)
        count <= 4'b0001; // Wrap around to 1
    end else begin
        count <= count + 1'b1; // Increment count
    end
end

assign q = count;

endmodule
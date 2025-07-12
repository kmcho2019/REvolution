module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count = 4'd1; // Initialize count to 1 (1'd1 is the same as 4'd0001)

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 1
        count <= 4'd1;
    end else if (count == 4'd10) begin
        // If count reaches 10, reset it back to 1
        count <= 4'd1;
    end else begin
        // Increment count by 1
        count <= count + 1'b1;
    end
end

assign q = count;

endmodule
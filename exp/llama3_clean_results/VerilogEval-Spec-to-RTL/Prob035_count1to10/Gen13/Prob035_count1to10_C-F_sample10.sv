module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count = 4'd1; // Initialize counter to 1

always @(posedge clk) begin
    if (reset || count == 4'd10) begin
        count <= 4'd1; // Reset counter to 1
    end else begin
        count <= count + 1; // Increment counter
    end
end

assign q = count; // Directly assign counter value to output q

endmodule
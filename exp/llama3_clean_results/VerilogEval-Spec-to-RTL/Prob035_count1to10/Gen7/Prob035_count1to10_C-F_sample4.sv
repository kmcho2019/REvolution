module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count = 1;

always @(posedge clk) begin
    if (reset) begin
        count <= 1; // Reset count to 1
    end else if (count == 10) begin
        count <= 1; // Wrap around to 1 after 10
    end else begin
        count <= count + 1; // Increment count by 1
    end
end

assign q = count;

endmodule
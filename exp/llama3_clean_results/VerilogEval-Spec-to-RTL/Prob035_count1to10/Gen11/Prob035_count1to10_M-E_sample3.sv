module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Reset count to 1
    end else if (count == 4'd10) begin
        count <= 4'd1; // Wrap around to 1 after 10
    end else begin
        // For the lower 3 bits, simply increment
        // The MSB will be handled implicitly by the counter's wraparound
        count <= count + 1;
    end
end

assign q = count;

endmodule
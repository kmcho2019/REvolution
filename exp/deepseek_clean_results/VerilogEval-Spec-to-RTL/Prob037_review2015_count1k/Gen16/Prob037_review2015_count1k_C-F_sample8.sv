module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire upper_bits_match = (q[9:5] == 5'b11111);  // Upper 5 bits = 31
wire terminal_count = upper_bits_match & (q[4:0] == 5'b00111);  // Lower 5 bits = 7

always @(posedge clk) begin
    if (reset) begin
        q <= 10'b0;
    end
    else begin
        q <= terminal_count ? 10'b0 : q + 1'b1;
    end
end

endmodule
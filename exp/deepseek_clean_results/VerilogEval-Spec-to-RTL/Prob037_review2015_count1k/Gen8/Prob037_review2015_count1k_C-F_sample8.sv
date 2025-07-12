module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

// Break comparison into upper 6 bits (15) and lower 4 bits (15)
// 999 in binary is 1111100111 (upper 6: 111110 = 62, lower 4: 0111 = 7)
wire upper_match = (q[9:4] == 6'b111110);  // Check upper 6 bits == 62
wire lower_match = (q[3:0] == 4'b0111);    // Check lower 4 bits == 7
wire terminal_count = upper_match & lower_match;

always @(posedge clk) begin
    if (reset) begin
        q <= 10'b0;
    end
    else begin
        q <= terminal_count ? 10'b0 : q + 1'b1;
    end
end

endmodule
module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire upper_bits_match = (q[9:5] == 5'b11111);  // Check if upper 5 bits are 31 (999/32 = 31.2)
wire lower_bits_match = (q[4:0] == 5'b00111);  // Check if lower 5 bits are 7 (999%32 = 7)
wire terminal_count = upper_bits_match & lower_bits_match;

always @(posedge clk) begin
    if (reset) begin
        q <= 10'b0;
    end
    else begin
        if (terminal_count) begin
            q <= 10'b0;
        end
        else begin
            q <= q + 1'b1;
        end
    end
end

endmodule
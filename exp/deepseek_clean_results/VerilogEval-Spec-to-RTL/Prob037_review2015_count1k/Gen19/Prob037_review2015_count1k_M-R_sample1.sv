module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire upper_bits_match = (q[9:5] == 5'b11111);
wire lower_bits_match = (q[4:0] == 5'b00111);
wire terminal_count = upper_bits_match & lower_bits_match;

wire [9:0] next_q = reset ? 10'b0 : 
                   (terminal_count ? 10'b0 : q + 1'b1);

always @(posedge clk) begin
    q <= next_q;
end

endmodule
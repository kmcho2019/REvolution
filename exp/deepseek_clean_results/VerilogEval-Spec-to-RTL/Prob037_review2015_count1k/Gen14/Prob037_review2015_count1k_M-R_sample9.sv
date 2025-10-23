module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

// Terminal count detection (999 in binary is 1111100111)
wire terminal_count = (q == 10'd999);

// Next counter value logic
wire [9:0] next_q = reset ? 10'd0 : 
                   (terminal_count ? 10'd0 : q + 1'b1);

always @(posedge clk) begin
    q <= next_q;
end

endmodule
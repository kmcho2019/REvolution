module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire enable_count;
wire [3:0] next_q;

// Enable counting only if reset is not active and count less than 9
assign enable_count = ~reset & (q != 4'd9);

// Next-state logic with gated counting
assign next_q = reset ? 4'd0 :
                enable_count ? q + 4'd1 :
                q;

always @(posedge clk) begin
    q <= next_q;
end

endmodule
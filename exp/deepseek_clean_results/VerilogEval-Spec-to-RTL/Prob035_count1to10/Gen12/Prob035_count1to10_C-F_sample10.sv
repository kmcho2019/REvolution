module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

// Combinational next state logic
assign next_q = (q == 4'b1010) ? 4'b0001 :  // Clear wrap-around at 10
                q + 4'b0001;                // Normal increment

// Sequential state update
always @(posedge clk) begin
    q <= reset ? 4'b0001 : next_q;  // Efficient synchronous reset
end

endmodule
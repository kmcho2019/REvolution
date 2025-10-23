module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire [9:0] next_q;

// Combinational next-state logic
assign next_q = (reset) ? 10'b0 : 
                (q == 10'd999) ? 10'b0 : 
                q + 1'b1;

// Sequential state update
always @(posedge clk) begin
    q <= next_q;
end

endmodule
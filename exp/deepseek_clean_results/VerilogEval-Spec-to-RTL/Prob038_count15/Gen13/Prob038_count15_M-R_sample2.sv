module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

// Combinational next state logic
assign next_q = (reset) ? 4'b0000 : (q + 1);

// Sequential state register
always @(posedge clk) begin
    q <= next_q;
end

endmodule
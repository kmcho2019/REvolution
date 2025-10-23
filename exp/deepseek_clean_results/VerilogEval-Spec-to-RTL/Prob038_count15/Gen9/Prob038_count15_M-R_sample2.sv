module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

// Combinational next state logic
assign next_q = q + 1;

// Sequential state update
always @(posedge clk) begin
    if (reset) q <= 4'b0;
    else q <= next_q;
end

endmodule
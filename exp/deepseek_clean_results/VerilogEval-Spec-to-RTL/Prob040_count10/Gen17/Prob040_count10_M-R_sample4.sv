module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

// Combinational next state logic
assign next_q = (q[3] & q[0]) ? 4'b0000 : q + 1'b1;

// Sequential state update
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else begin
        q <= next_q;
    end
end

endmodule
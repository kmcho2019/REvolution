module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire [9:0] next_q;

// Combinational next-state logic
assign next_q = (reset || q == 10'd999) ? 10'd0 : q + 1'b1;

// Sequential logic (register)
always @(posedge clk) begin
    q <= next_q;
end

endmodule
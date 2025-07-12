module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire [9:0] next_q;

// Combinational next-state logic
assign next_q = (q == 10'd999) ? 10'd0 : (q + 10'd1);

// Sequential state storage
always @(posedge clk) begin
    if (reset) begin
        q <= 10'd0;
    end else begin
        q <= next_q;
    end
end

endmodule
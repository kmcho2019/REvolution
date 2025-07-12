module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire will_overflow = (q == 4'b1001);
wire [3:0] next_count = q + 1'b1;
wire [3:0] enabled_next = slowena ? (will_overflow ? 4'b0000 : next_count) : q;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else begin
        q <= enabled_next;
    end
end

endmodule
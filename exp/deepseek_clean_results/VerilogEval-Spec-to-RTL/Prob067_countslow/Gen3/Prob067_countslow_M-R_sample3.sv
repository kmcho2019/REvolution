module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire overflow = q[3] & q[0];
wire [3:0] next_q = slowena ? (overflow ? 4'b0000 : q + 1'b1) : q;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        q <= next_q;
    end
end

endmodule
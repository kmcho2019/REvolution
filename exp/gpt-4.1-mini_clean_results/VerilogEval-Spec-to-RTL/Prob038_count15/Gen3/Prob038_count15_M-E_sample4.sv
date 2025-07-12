module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire toggle0, toggle1, toggle2, toggle3;

assign toggle0 = 1'b1;                     // q[0] toggles every clock
assign toggle1 = q[0];                     // q[1] toggles when q[0] is high
assign toggle2 = q[0] & q[1];              // q[2] toggles when q[0] & q[1] are high
assign toggle3 = q[0] & q[1] & q[2];       // q[3] toggles when q[0] & q[1] & q[2] are high

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else begin
        q[0] <= q[0] ^ toggle0;
        q[1] <= q[1] ^ toggle1;
        q[2] <= q[2] ^ toggle2;
        q[3] <= q[3] ^ toggle3;
    end
end

endmodule
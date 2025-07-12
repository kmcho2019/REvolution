module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(negedge clk) begin
    if (reset) begin
        q[7] <= 1'b0;  // MSB
        q[6] <= 1'b1;
        q[5] <= 1'b0;
        q[4] <= 1'b0;
        q[3] <= 1'b0;
        q[2] <= 1'b0;
        q[1] <= 1'b1;
        q[0] <= 1'b0;   // LSB (0x34 = 00110100)
    end else begin
        q <= d;
    end
end

endmodule
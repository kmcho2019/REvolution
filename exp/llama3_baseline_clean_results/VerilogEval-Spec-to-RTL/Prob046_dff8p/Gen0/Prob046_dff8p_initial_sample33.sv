module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

integer i;
always @(negedge clk) begin
    if (reset) begin
        for (i = 0; i < 8; i = i + 1) begin
            if (i < 5) q[i] <= 0; // Since 0x34 in binary is 00110100
            else if (i == 5) q[i] <= 1;
            else if (i == 6) q[i] <= 0;
            else q[i] <= 0;
        end
    end
    else begin
        q <= d;
    end
end

endmodule
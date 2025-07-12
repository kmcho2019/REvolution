module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | 1;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= (q >> 1) ^ (q[0] ? TAP_MASK : 0);
        end
    end

endmodule
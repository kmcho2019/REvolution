module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback = q[0];
localparam TAP_MASK = 32'h80040003;  // Bits 31,21,1,0 (0-based)

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        q <= {1'b0, q[31:1]} ^ (feedback ? TAP_MASK : 32'b0);
    end
end

endmodule
module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

localparam TAP_MASK = 32'b10000000000100000000000000000011;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        q <= {q[0], q[31:1]} ^ (q[0] ? TAP_MASK : 32'b0);
    end
end

endmodule
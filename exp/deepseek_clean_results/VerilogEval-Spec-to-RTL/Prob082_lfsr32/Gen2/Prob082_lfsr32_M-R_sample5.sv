module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback;
wire [31:0] next_q;

assign feedback = q[0];

assign next_q[31] = q[30] ^ (feedback & 1'b1);  // Tap at 32 (bit 31)
assign next_q[30:22] = q[29:21];
assign next_q[21] = q[20] ^ (feedback & 1'b1);  // Tap at 22 (bit 21)
assign next_q[20:2] = q[19:1];
assign next_q[1] = q[0] ^ (feedback & 1'b1);    // Tap at 2 (bit 1)
assign next_q[0] = feedback;                    // Tap at 1 (bit 0)

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        q <= next_q;
    end
end

endmodule
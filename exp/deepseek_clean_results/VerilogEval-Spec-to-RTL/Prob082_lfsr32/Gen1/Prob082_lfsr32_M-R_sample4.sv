module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback = q[0];  // The LSB is the feedback term

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Handle each bit position separately
        q[31] <= feedback;
        q[30:22] <= q[31:23];
        q[21] <= q[22] ^ feedback;
        q[20:2] <= q[21:3];
        q[1] <= q[2] ^ feedback;
        q[0] <= q[1] ^ feedback;
    end
end

endmodule
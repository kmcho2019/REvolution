module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback = q[0];  // The LSB is the feedback term
wire tap_21 = q[22] ^ feedback;
wire tap_1 = q[2] ^ feedback;
wire tap_0 = tap_1 ^ feedback;  // q[1] is same as q[2]^feedback from previous cycle

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Parallel computation of all bits
        q[31] <= feedback;
        q[30:22] <= q[31:23];
        q[21] <= tap_21;
        q[20:2] <= q[21:3];
        q[1] <= tap_1;
        q[0] <= tap_0;
    end
end

endmodule
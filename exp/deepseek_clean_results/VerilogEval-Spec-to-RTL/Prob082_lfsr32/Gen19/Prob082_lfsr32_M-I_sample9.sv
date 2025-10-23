module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

reg feedback;
wire tap_22 = q[22] ^ feedback;
wire tap_2 = q[2] ^ feedback;
wire tap_1 = q[1] ^ feedback;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
        feedback <= 1'b1;
    end else begin
        feedback <= q[0];
        q <= {feedback, q[31:23], tap_22, q[21:3], tap_2, tap_1};
    end
end

endmodule
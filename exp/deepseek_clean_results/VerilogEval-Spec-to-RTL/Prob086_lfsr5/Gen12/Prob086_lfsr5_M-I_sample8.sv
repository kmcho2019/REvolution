module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];
wire tap_xor = q[3] ^ feedback;

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q <= {feedback, q[4], tap_xor, q[2:1]};
    end
end

endmodule
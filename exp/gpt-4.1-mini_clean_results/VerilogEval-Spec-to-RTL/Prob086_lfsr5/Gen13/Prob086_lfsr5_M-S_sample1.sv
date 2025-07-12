module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= {feedback, q[4] ^ feedback, q[3], q[2] ^ feedback, q[1]};
end

endmodule
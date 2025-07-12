module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback;
assign feedback = q[0] ^ q[4] ^ q[2];

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= {feedback, q[4:1]};
end

endmodule
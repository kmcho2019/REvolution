module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else begin
        q[0] <= q[1];
        q[1] <= q[2];
        q[2] <= q[3] ^ feedback;
        q[3] <= q[4];
        q[4] <= feedback;
    end
end

endmodule
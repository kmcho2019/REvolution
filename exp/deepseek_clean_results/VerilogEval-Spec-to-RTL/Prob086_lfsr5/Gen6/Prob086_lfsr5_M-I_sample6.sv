module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback;
assign feedback = q[0];

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q <= {feedback, q[4], q[3] ^ feedback, q[2:1]};
    end
end

endmodule
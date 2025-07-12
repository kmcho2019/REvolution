module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else begin
        wire fb = q[0];
        q <= {q[4] ^ fb, q[4:3], q[2] ^ fb, q[2:1]};
    end
end

endmodule
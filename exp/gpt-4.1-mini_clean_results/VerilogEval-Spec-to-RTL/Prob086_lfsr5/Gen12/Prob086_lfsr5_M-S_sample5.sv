module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        wire feedback = q[0] ^ q[2]; // taps at bit 5 (q[4]) and bit 3 (q[2])
        q <= {feedback, q[4:1]};
    end
end

endmodule
module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // feedback is q[0]
        // taps at bits 5 (q[4]) and 3 (q[2]) XORed with q[0]
        q <= {q[3], q[2] ^ q[0], q[1], q[0], q[0]};
    end
end

endmodule
module TopModule (
    input         clk,
    input         reset,
    output reg [4:0] q
);

wire feedback = q[0] ^ q[2]; // taps at bit 5 (q[4]) and 3 (q[2]) combined with q[0]

reg [4:0] next_q;

always @(*) begin
    // Shift right by one, inject feedback at MSB
    next_q = {feedback, q[4:1]};
end

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= next_q;
    end
end

endmodule
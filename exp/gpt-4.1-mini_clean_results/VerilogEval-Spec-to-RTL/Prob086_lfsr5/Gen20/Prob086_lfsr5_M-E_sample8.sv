module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

wire feedback;

assign feedback = q[4] ^ q[2];  // taps at bit 5 (q[4]) and 3 (q[2])

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // synchronous reset to non-zero state
    end else begin
        q <= {feedback, q[4:1]};  // shift right with feedback at MSB
    end
end

endmodule
module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

reg [4:0] next_q;

always @(*) begin
    // Compute feedback bit as q[0]
    // Shift right with XOR feedback at bits 4 and 2 (positions 5 and 3)
    next_q[0] = q[1];
    next_q[1] = q[2];
    next_q[2] = q[3] ^ q[0];
    next_q[3] = q[4];
    next_q[4] = q[0];
end

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= next_q;
end

endmodule
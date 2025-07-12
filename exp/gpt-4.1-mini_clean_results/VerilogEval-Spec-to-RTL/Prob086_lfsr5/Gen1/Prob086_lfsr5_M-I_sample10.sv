module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];
reg [4:0] next_q;

always @(*) begin
    // Compute next state of the LFSR bits
    // Shift right by one, apply XOR feedback on tap positions q[4] and q[2]
    next_q[0] = q[1];
    next_q[1] = q[2];
    next_q[2] = q[3] ^ feedback; // tap at bit 3 (q[2])
    next_q[3] = q[4];
    next_q[4] = feedback;        // tap at bit 5 (q[4])
end

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= next_q;
    end
end

endmodule
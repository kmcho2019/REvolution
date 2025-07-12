module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] q_next;

// Combinational logic to calculate the new MSB
assign q_next[31] = q[0] ^ q[1] ^ q[21] ^ q[31];

// Combinational logic to shift the register to the right and apply XOR at tap positions
assign q_next[30:22] = q[31:23];
assign q_next[21] = q[0] ^ q[22];
assign q_next[20:2] = q[21:3];
assign q_next[1] = q[0] ^ q[2];
assign q_next[0] = q[31];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        q <= q_next; // Update state register
    end
end

endmodule
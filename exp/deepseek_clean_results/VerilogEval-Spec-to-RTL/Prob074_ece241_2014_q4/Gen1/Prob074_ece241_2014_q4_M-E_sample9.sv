module TopModule (
    input clk,
    input x,
    output z
);

    // 3-bit shift register to store states
    reg [2:0] shift_reg = 3'b000;  // Initialized to 0

    // Feedback connections:
    // bit 0: XOR feedback
    // bit 1: AND feedback (complemented)
    // bit 2: OR feedback (complemented)
    wire xor_in = x ^ shift_reg[0];
    wire and_in = x & ~shift_reg[1];
    wire or_in = x | ~shift_reg[2];

    // Update shift register on clock edge
    always @(posedge clk) begin
        shift_reg <= {or_in, and_in, xor_in};
    end

    // Output is NOR of all shift register bits
    assign z = ~(|shift_reg);

endmodule
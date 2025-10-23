module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback = q[0]; // feedback from LSB before shift
    reg  [4:0] next_q;

    always @(*) begin
        // Compute next state of LFSR with taps at bits 5 and 3 (q[4], q[2])
        // Shift right by one; tapped bits XORed with feedback
        next_q[0] = q[1];
        next_q[1] = q[2];
        next_q[2] = q[3] ^ feedback; // tap at bit 3
        next_q[3] = q[4];
        next_q[4] = feedback;         // tap at bit 5 (MSB) loads feedback
    end

    always @(posedge clk) begin
        if (reset)
            q <= 5'b00001;          // synchronous reset to 1, avoiding all-zero state
        else
            q <= next_q;
    end

endmodule
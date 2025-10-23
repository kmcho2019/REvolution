module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // synchronous reset to 1
        end else begin
            // Compute feedback bit (XOR taps with LSB)
            // taps at bit 5 (q[4]) and bit 3 (q[2]) XORed with q[0]
            wire feedback = q[0] ^ q[2] ^ q[4];
            q <= {feedback, q[4:1]}; // shift right and insert feedback at MSB
        end
    end

endmodule
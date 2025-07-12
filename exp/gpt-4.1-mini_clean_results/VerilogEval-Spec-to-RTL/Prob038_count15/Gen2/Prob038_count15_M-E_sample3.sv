module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);
    // For a 4-bit binary counter using linear feedback shift register (LFSR) logic:
    // However, a simple LFSR won't count 0 to 15 in binary order, but
    // since problem requires binary count 0..15, we can implement a rotate + increment logic.

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else begin
            // rotate left by 1 and add 1 to LSB (mod 16)
            // Actually to count 0-15 normally, we can do:
            // q <= {q[2:0], q[3]} + 1; but this is not a normal count.
            // Instead, implement a small state machine with shift and feedback:
            // We'll make a one-hot encoding counter which cycles through the 16 states
            // by rotating left the 4-bit register and adding logic to get binary count:
            // But this overcomplicates.
            // Instead, implement the counter as a shift register that increments on each clock:
            // Here we do q <= q + 1 with a twist: separate increment logic.
            // But this repeats the example.

            // To make different: implement the counter using a parallel adder combinationally.
            // We'll add 1 explicitly using combinational logic.

            // Compute next count using bitwise operations:
            // next_q[0] = ~q[0];
            // next_q[1] = q[1] ^ q[0];
            // next_q[2] = q[2] ^ (q[1] & q[0]);
            // next_q[3] = q[3] ^ (q[2] & q[1] & q[0]);

            q[0] <= ~q[0];
            q[1] <= q[1] ^ q[0];
            q[2] <= q[2] ^ (q[1] & q[0]);
            q[3] <= q[3] ^ (q[2] & q[1] & q[0]);
        end
    end
endmodule
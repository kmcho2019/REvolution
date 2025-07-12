module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift left: bits move towards MSB, input data at LSB
            // This implements MSB-first shifting by shifting left and inserting data at LSB.
            q[3] <= q[2];
            q[2] <= q[1];
            q[1] <= q[0];
            q[0] <= data;
        end else if (count_ena) begin
            // Manual decrement by 1 using ripple borrow logic (q = q - 1)
            // borrow_0 from LSB subtract
            // borrow_i calculated from previous borrow and bit
            reg b0, b1, b2, b3;
            b0 = ~q[0];              // borrow out from bit 0 subtraction
            q[0] <= q[0] ^ 1'b1;    // subtracting 1 flips bit0
            b1 = (b0 & ~q[1]);
            q[1] <= q[1] ^ b0;
            b2 = (b1 & ~q[2]);
            q[2] <= q[2] ^ b1;
            b3 = (b2 & ~q[3]);
            q[3] <= q[3] ^ b2;
            // ignore overflow borrow b3 as q is 4-bit
        end
    end

endmodule
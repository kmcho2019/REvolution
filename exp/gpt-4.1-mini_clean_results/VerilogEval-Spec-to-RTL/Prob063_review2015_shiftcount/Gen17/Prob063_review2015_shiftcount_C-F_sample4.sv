module TopModule (
    input          clk,
    input          shift_ena,
    input          count_ena,
    input          data,
    output reg [3:0] q
);

    // Ripple borrow decrement logic
    wire borrow0 = 1'b1;  // decrement by 1, initial borrow-in
    wire b1 = (~q[0]) & borrow0;
    wire b2 = (~q[1]) & b1;
    wire b3 = (~q[2]) & b2;
    wire [3:0] dec_q;
    assign dec_q[0] = q[0] ^ borrow0;
    assign dec_q[1] = q[1] ^ b1;
    assign dec_q[2] = q[2] ^ b2;
    assign dec_q[3] = q[3] ^ b3;

    // Combined control signal, shift_ena has priority if both are 1
    wire do_shift = shift_ena;
    wire do_count = (~shift_ena) & count_ena;

    always @(posedge clk) begin
        if (do_shift)
            q <= {q[2:0], data};  // shift left, MSB first, input at LSB
        else if (do_count)
            q <= dec_q;           // decrement with ripple borrow logic
        // else hold current q
    end

endmodule
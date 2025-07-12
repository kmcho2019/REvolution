module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback;
    reg [4:0] next_q;

    assign feedback = q[0]; // feedback from LSB before shift

    always @(*) begin
        // Shift right by one and apply XOR feedback on tapped bits:
        // taps at bits 5 and 3 correspond to q[4] and q[2]
        next_q[0] = q[1];
        next_q[1] = q[2];
        next_q[2] = q[3] ^ feedback; // tap at bit 3
        next_q[3] = q[4];
        next_q[4] = feedback;         // MSB loads feedback directly
    end

    always @(posedge clk) begin
        if (reset)
            q <= 5'b00001;  // synchronous reset to 1
        else
            q <= next_q;
    end

endmodule
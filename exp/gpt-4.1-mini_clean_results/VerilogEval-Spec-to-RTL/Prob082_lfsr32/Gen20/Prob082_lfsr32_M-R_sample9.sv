module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    reg [31:0] next_q;
    wire feedback = q[0];

    always @(*) begin
        // Initialize next_q as shifted right by 1
        next_q = q >> 1;

        // Apply XOR with feedback at tap positions:
        // taps at bits 32(31), 22(21), 2(1), 1(0)
        next_q[31] = q[31] ^ feedback; // bit 32 tap
        next_q[21] = q[21] ^ feedback; // bit 22 tap
        next_q[1]  = q[1]  ^ feedback; // bit 2 tap
        next_q[0]  = q[0]  ^ feedback; // bit 1 tap (LSB)
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule
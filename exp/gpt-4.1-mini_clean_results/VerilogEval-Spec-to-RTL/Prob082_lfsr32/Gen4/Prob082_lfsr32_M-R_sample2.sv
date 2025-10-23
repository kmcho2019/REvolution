module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    wire fb = q[0]; // feedback from LSB

    integer i;
    reg [31:0] next_q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Compute next state of LFSR with taps at bits 31,21,1,0 (0-based)
            // According to Galois LFSR, next_q[i] = q[i-1] XOR fb if tap, else q[i-1]
            // For i=0, next_q[0] = q[31] XOR fb if tap, else q[31]. But since we shift right,
            // next_q[0] comes from q[1], so handle i=0 carefully:

            for (i = 31; i >= 1; i = i - 1) begin
                // taps: 31,21,1,0; So if i is tap: XOR with fb; else just shift
                if ((i == 31) || (i == 21) || (i == 1)) begin
                    next_q[i] = q[i-1] ^ fb;
                end else begin
                    next_q[i] = q[i-1];
                end
            end
            // For bit 0 (LSB), tap at 0 means next_q[0] = q[31] ^ fb if tap, else q[31]
            // Our taps include bit 0, so next_q[0] = q[31] ^ fb;
            next_q[0] = q[31] ^ fb;

            q <= next_q;
        end
    end

endmodule
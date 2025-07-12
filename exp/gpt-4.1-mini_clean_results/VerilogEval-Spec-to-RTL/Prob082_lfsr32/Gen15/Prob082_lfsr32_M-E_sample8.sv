module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    integer i;
    wire feedback = q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right by one with selective XOR feedback at taps
            // Taps at bits 32(31), 22(21), 2(1), and 1(0)
            for (i = 31; i > 0; i = i - 1) begin
                if (i == 31 || i == 21 || i == 1) 
                    q[i] <= q[i-1] ^ feedback;
                else
                    q[i] <= q[i-1];
            end
            // LSB takes feedback bit directly (shift in)
            q[0] <= feedback;
        end
    end
endmodule
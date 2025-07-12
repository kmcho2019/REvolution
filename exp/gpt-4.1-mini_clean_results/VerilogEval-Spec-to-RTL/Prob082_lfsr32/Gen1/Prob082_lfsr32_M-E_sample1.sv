module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            wire fb = q[0];
            reg [31:0] next_q;

            // Bit 31 (tap): next bit is q[31-1] XOR fb => q[30] ^ fb
            next_q[31] = q[31-1] ^ fb;

            // For bits 30 down to 22 (no tap): next bit = q[i-1]
            integer i;
            for (i = 30; i >= 22; i = i - 1) begin
                next_q[i] = q[i-1];
            end

            // Bit 21 (tap): next bit = q[20] ^ fb
            next_q[21] = q[20] ^ fb;

            // Bits 20 down to 2 (no tap): next bit = q[i-1]
            for (i = 20; i >= 2; i = i - 1) begin
                next_q[i] = q[i-1];
            end

            // Bit 1 (tap): next bit = q[0] ^ fb
            next_q[1] = q[0] ^ fb;

            // Bit 0: input the feedback bit
            next_q[0] = fb;

            q <= next_q;
        end
    end

endmodule
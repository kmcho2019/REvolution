module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    wire fb = q[0];
    reg [31:0] next_q;
    integer i;

    always @(*) begin
        // Bit 0 always takes q[1] shifted down
        next_q[0] = q[1];
        // For bits 1 to 31, apply taps XOR with feedback as per Galois LFSR
        for (i = 1; i < 32; i = i + 1) begin
            if (i == 31 || i == 21 || i == 1)
                next_q[i] = q[i-1] ^ fb;
            else
                next_q[i] = q[i-1];
        end
    end

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end
endmodule
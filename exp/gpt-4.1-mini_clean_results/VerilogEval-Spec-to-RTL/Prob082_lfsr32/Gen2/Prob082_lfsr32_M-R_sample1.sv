module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    reg [31:0] next_q;

    always @* begin
        next_q = q >> 1; // default shift right
        // Apply taps by XORing with feedback
        next_q[31] = q[31] ^ feedback; // bit 32 tap (index 31)
        next_q[21] = q[21] ^ feedback; // bit 22 tap (index 21)
        next_q[1]  = q[1]  ^ feedback; // bit 2 tap  (index 1)
        next_q[0]  = q[0]  ^ feedback; // bit 1 tap  (index 0)
    end

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule
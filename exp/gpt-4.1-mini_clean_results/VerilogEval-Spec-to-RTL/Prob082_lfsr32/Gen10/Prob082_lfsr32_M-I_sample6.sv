module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    integer i;
    wire feedback = q[0];
    reg [31:0] next_q;

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

    always @* begin
        next_q[31] = q[0] ^ q[31];                // tap at bit 32
        next_q[21] = q[0] ^ q[21];                // tap at bit 22
        next_q[1]  = q[0] ^ q[1];                 // tap at bit 2
        next_q[0]  = q[1];                        // bit 1 (non-tap) shifts right

        // For all other bits that are not taps and not bit 0,
        // just shift right without XOR
        for (i = 30; i >= 22; i = i - 1)
            next_q[i] = q[i+1];
        for (i = 20; i >= 2; i = i - 1)
            next_q[i] = q[i+1];
    end
endmodule
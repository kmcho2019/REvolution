module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Combinational calculation of next LFSR state
    wire feedback = q[0];
    wire [31:0] lfsr_next;

    assign lfsr_next[31] = feedback;
    assign lfsr_next[30:22] = q[31:23];
    assign lfsr_next[21] = q[22] ^ feedback;  // tap bit 22 (idx 21)
    assign lfsr_next[20:2] = q[21:3];
    assign lfsr_next[1] = q[2] ^ feedback;    // tap bit 2 (idx 1)
    assign lfsr_next[0] = q[1] ^ feedback;    // tap bit 1 (idx 0)

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= lfsr_next;
    end

endmodule
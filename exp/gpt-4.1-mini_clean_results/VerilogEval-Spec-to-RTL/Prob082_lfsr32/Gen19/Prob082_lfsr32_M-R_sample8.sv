module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    wire [31:0] next_q;

    assign next_q[31] = feedback;
    assign next_q[30:22] = q[31:23];
    assign next_q[21] = q[22] ^ feedback; // tap at bit 22 (idx 21)
    assign next_q[20:2] = q[21:3];
    assign next_q[1] = q[2] ^ feedback;   // tap at bit 2 (idx 1)
    assign next_q[0] = q[1] ^ feedback;   // tap at bit 1 (idx 0)

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule
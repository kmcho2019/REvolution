module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    wire [31:0] next_q;

    assign next_q[31] = feedback;
    assign next_q[30:0] = q[31:1];

    // Apply XOR with feedback at tap positions 22, 2, 1
    assign next_q[21] = next_q[21] ^ feedback; // bit 22 tap (index 21)
    assign next_q[1]  = next_q[1]  ^ feedback; // bit 2 tap (index 1)
    assign next_q[0]  = next_q[0]  ^ feedback; // bit 1 tap (index 0)

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule
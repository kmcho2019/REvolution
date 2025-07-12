module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire [3:0] next_q;

    // Implement bitwise increment logic combinationally to reduce switching glitches
    assign next_q[0] = ~q[0];
    assign next_q[1] = q[1] ^ q[0];
    assign next_q[2] = q[2] ^ (q[1] & q[0]);
    assign next_q[3] = q[3] ^ (q[2] & q[1] & q[0]);

    always @(posedge clk) begin
        if (reset)
            q <= 4'b0000;
        else
            q <= next_q;
    end

endmodule
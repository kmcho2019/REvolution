module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback;
    assign feedback = q[0] ^ q[21] ^ q[1] ^ q[0]; // taps at bits 32, 22, 2, and 1 (indices 31,21,1,0); q[0] tapped twice means XOR q[0] twice -> cancels out

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= {feedback, q[31:1]};
    end

endmodule
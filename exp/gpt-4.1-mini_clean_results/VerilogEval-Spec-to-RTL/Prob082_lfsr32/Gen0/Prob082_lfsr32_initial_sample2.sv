module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions: 32, 22, 2, 1 correspond to q[31], q[21], q[1], q[0]
    // Feedback bit = q[0] XOR q[1] XOR q[21] XOR q[31]
    wire feedback = q[0] ^ q[1] ^ q[21] ^ q[31];

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else begin
            q <= {q[30:0], feedback};
        end
    end

endmodule
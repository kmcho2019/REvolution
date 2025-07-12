module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else begin
            // XOR the tapped bits (positions 32,22,2,1 correspond to q[31], q[21], q[1], q[0])
            wire feedback = q[0] ^ q[1] ^ q[21] ^ q[31];
            q <= {feedback, q[31:1]};
        end
    end
endmodule
module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback;

    // Compute feedback as XOR of q[0], q[31], q[21], and q[1]
    assign feedback = q[0] ^ q[31] ^ q[21] ^ q[1];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right by one, insert feedback at MSB
            q <= {feedback, q[31:1]};
        end
    end

endmodule
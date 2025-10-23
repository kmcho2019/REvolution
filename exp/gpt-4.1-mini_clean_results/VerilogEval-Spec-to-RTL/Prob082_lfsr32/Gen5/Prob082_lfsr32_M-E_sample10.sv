module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback;
    // Compute feedback as XOR of tapped bits and the current LSB (q[0])
    // Taps at bits 31, 21, 1, and 0 (0-based indexing)
    assign feedback = q[31] ^ q[21] ^ q[1] ^ q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right by 1, insert feedback at MSB
            q <= {feedback, q[31:1]};
        end
    end

endmodule
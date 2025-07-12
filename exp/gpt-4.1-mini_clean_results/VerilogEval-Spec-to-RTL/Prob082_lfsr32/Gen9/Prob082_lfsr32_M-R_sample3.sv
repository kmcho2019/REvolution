module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback;

    // Compute feedback by XORing the tapped bits of q: bits 31, 21, 1, and 0
    assign feedback = q[0] ^ q[1] ^ q[21] ^ q[31];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right by one and insert feedback bit at MSB
            q <= {feedback, q[31:1]};
        end
    end

endmodule
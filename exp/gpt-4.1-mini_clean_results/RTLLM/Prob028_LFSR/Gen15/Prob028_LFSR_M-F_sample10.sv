module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback;
    // Compute feedback as inverted XOR of bits 3 and 2
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;            // Reset to zero as per problem statement
        else
            out <= {out[2:0], feedback}; // Shift left, insert feedback at LSB
    end

endmodule
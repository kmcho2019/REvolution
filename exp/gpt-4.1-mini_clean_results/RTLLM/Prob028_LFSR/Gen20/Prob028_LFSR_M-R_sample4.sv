module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback;

    // Calculate feedback as inverted XOR of bits 3 and 2 of current state
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0001; // non-zero seed on reset
        else
            out <= {out[2:0], feedback}; // shift left and insert feedback at LSB
    end

endmodule
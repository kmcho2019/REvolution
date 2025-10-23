module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback;

    // Compute feedback as inverted XOR of bits 3 and 2
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 4'b0001;     // non-zero seed on reset
        else
            out <= {out[2:0], feedback};  // shift left and insert feedback bit
    end

endmodule
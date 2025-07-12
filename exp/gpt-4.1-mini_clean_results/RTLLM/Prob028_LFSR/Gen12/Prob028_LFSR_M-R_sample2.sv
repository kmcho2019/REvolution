module LFSR (
    input  wire       clk,
    input  wire       rst,   // active high synchronous reset
    output reg  [3:0] out
);

    wire feedback;
    // feedback is inverted XOR of MSB (out[3]) and second MSB (out[2])
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= {out[2:0], feedback};  // shift left, feedback into LSB
    end

endmodule
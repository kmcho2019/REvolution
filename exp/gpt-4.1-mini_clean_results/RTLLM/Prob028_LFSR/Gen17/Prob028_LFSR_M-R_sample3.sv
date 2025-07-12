module LFSR(
    input  wire       clk,
    input  wire       rst,   // synchronous active-high reset
    output reg  [3:0] out
);

    // Feedback is inverted XOR of bits 3 and 2 of current state
    wire feedback;
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;  // synchronous reset to zero
        end else begin
            out <= {out[2:0], feedback};  // shift left and insert feedback at LSB
        end
    end

endmodule
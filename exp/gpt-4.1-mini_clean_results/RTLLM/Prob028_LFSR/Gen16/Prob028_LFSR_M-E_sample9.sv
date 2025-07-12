module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback;
    // Feedback is inverse of XOR of out[1] and out[0]
    assign feedback = ~(out[1] ^ out[0]);

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 4'b1000;  // Non-zero seed (MSB set)
        else
            out <= {feedback, out[3:1]}; // Shift right and insert feedback at MSB
    end

endmodule
module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback = out[1] ^ out[0];

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0001;  // Initialize to a non-zero value to start the sequence
        else
            out <= {feedback, out[3:1]};
    end

endmodule
module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// Feedback polynomial can still be parameterized
parameter FEEDBACK_POLY = 4'b1100;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0001; // Initialize to non-zero state (better for LFSR operation)
    end
    else begin
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule
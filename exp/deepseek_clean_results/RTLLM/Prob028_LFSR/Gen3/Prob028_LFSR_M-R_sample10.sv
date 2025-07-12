module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// Feedback polynomial (same as original)
parameter FEEDBACK_POLY = 4'b1100;

// Feedback calculation as continuous assignment
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// Register update logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0001; // Non-zero initialization
    end
    else begin
        out <= {out[2:0], feedback};
    end
end

endmodule
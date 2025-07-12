module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// Feedback calculation
wire feedback = ~(out[3] ^ out[2]);

// Next state calculation (continuous assignment)
wire [3:0] next_out = {out[2:0], feedback};

// Register update (sequential logic)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000;
    end else begin
        out <= next_out;
    end
end

endmodule
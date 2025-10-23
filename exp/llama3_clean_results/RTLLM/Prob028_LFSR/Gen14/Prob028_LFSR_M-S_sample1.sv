module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// Sequential logic for updating the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0; // Initialize state to zero on reset
    end else begin
        // Calculate feedback and shift left
        out <= {out[2:0], out[3] ^ out[2]};
    end
end

endmodule
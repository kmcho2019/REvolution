module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback;

assign feedback = ~(out[3] ^ out[2]);  // XOR bits 3 and 2, then invert

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;  // Initialize to zero as specified
    end
    else begin
        out <= {out[2:0], feedback};  // Standard left shift
    end
end

endmodule
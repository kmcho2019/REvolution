module LFSR (
    input wire clk,       // 1-bit clock input
    input wire rst,       // 1-bit reset input
    output reg [3:0] out  // 4-bit output
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;  // Initialize to non-zero value
    end
    else begin
        // Left shift with inverted XOR feedback
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule
module LFSR #(
    parameter WIDTH = 4
) (
    input wire clk,
    input wire rst,
    output reg [WIDTH-1:0] lfsr_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Active high reset initializes to 0
        lfsr_out <= {WIDTH{1'b0}};
    end else begin
        // Shift left and insert inverted XOR of bits [3] and [2]
        lfsr_out <= {lfsr_out[WIDTH-2:0], ~(lfsr_out[WIDTH-1] ^ lfsr_out[WIDTH-2])};
    end
end

endmodule
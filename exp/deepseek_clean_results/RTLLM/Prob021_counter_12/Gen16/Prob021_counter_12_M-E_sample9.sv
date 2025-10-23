module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit Gray code counter output
);

// Gray code sequence for 0-11:
// 0000, 0001, 0011, 0010, 0110, 0111, 0101, 0100, 
// 1100, 1101, 1111, 1011, then back to 0000

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        case (out)
            // Gray code sequence
            4'b0000: out <= 4'b0001;
            4'b0001: out <= 4'b0011;
            4'b0011: out <= 4'b0010;
            4'b0010: out <= 4'b0110;
            4'b0110: out <= 4'b0111;
            4'b0111: out <= 4'b0101;
            4'b0101: out <= 4'b0100;
            4'b0100: out <= 4'b1100;
            4'b1100: out <= 4'b1101;
            4'b1101: out <= 4'b1111;
            4'b1111: out <= 4'b1011;
            4'b1011: out <= 4'b0000;  // Wrap around
            default: out <= 4'b0000;  // Safety case
        endcase
    end
    // else hold current value
end

// Convert Gray code to binary for output if needed
// (Optional - depends on system requirements)
wire [3:0] binary_out;
assign binary_out[3] = out[3];
assign binary_out[2] = out[3] ^ out[2];
assign binary_out[1] = out[3] ^ out[2] ^ out[1];
assign binary_out[0] = out[3] ^ out[2] ^ out[1] ^ out[0];

endmodule
module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Define tap positions (1-based indexing)
localparam TAP_32 = 1;
localparam TAP_22 = 1;
localparam TAP_2 = 1;
localparam TAP_1 = 1;

genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : lfsr_bit
        always @(posedge clk) begin
            if (reset) begin
                q[i] <= (i == 0); // Initialize to 1 (LSB) and 0 for others
            end else begin
                case (i)
                    // Special cases for tapped bits
                    31: q[i] <= q[0]; // Bit 32 (index 31) taps from LSB
                    21: q[i] <= q[22] ^ q[0]; // Bit 22 (index 21) taps from LSB
                    1: q[i] <= q[2] ^ q[0]; // Bit 2 (index 1) taps from LSB
                    0: q[i] <= q[1] ^ q[0]; // Bit 1 (index 0) taps from LSB
                    // Default case: shift right
                    default: q[i] <= q[i+1];
                endcase
            end
        end
    end
endgenerate

endmodule
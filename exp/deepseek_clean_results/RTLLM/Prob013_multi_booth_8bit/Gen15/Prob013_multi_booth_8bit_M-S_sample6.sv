module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Internal registers
    reg [8:0] multiplicand;  // 8-bit + sign
    reg [8:0] multiplier;    // 8-bit + sign
    reg [1:0] iter_ctr;      // 2-bit counter (0-4)

    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {a[7], a};
            multiplier <= {b[7], b};
            p <= 16'b0;
            iter_ctr <= 2'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Booth operation (Radix-4)
            case (multiplier[1:0])
                2'b01: p <= p + { {7{multiplicand[8]}}, multiplicand};
                2'b10: p <= p - { {7{multiplicand[8]}}, multiplicand};
                2'b11: p <= p - { {6{multiplicand[8]}}, multiplicand, 1'b0};
                2'b00: ; // No operation
            endcase

            // Update registers
            multiplicand <= multiplicand << 2;
            multiplier <= $signed(multiplier) >>> 2;

            // Check completion (4 iterations for 8 bits)
            if (iter_ctr == 2'd3) begin
                rdy <= 1'b1;
            end else begin
                iter_ctr <= iter_ctr + 1;
            end
        end
    end

endmodule
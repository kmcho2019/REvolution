module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg prev_lsb;          // Track previous LSB separately
    reg [4:0] ctr;         // 5-bit counter as specified

    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            prev_lsb <= 1'b0;
            p <= 16'b0;
            ctr <= 5'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Examine current 3 bits (2 current + 1 previous)
            case ({multiplier[1:0], prev_lsb})
                3'b000, 3'b111: ;  // No operation
                3'b001, 3'b010: p <= p + multiplicand;  // +A
                3'b101, 3'b110: p <= p - multiplicand;  // -A
                3'b011: p <= p + {multiplicand[14:0], 1'b0};   // +2A
                3'b100: p <= p - {multiplicand[14:0], 1'b0};   // -2A
            endcase

            // Prepare for next step
            multiplicand <= {multiplicand[13:0], 2'b0};  // Left shift by 2
            prev_lsb <= multiplier[0];                   // Save current LSB
            multiplier <= {{2{multiplier[15]}}, multiplier[15:2]}; // Arithmetic right shift by 2

            // Update counter and ready signal
            if (ctr == 5'd3) begin  // 4 cycles for 8 bits (0-3)
                rdy <= 1'b1;
            end else begin
                ctr <= ctr + 1;
            end
        end
    end

endmodule
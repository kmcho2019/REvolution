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
    reg [2:0] ctr;  // 3-bit counter (0-3)

    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Examine current 2 bits plus previous LSB
            case (multiplier[1:0])
                2'b01: p <= p + multiplicand;      // +A
                2'b10: p <= p - multiplicand;      // -A
                default: ;                         // No operation
            endcase

            // Shift multiplicand left by 2 for next iteration
            multiplicand <= multiplicand << 2;
            // Shift multiplier right by 2 (arithmetic)
            multiplier <= { {2{multiplier[15]}}, multiplier[15:2] };

            // Update counter and ready signal
            if (ctr == 3'd3) begin
                rdy <= 1'b1;
            end else begin
                ctr <= ctr + 1;
            end
        end
    end

endmodule
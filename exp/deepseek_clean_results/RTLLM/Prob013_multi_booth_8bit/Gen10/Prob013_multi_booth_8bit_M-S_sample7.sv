module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;  // 16-bit to handle shifts
    reg [8:0] multiplier;     // 9-bit to store prev LSB
    reg [2:0] iter_ctr;       // 3-bit counter (0-4)

    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 1'b0};  // Include initial prev LSB
            p <= 16'b0;
            iter_ctr <= 3'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Booth recoding and accumulation
            case (multiplier[2:0])
                3'b000, 3'b111: p <= p;
                3'b001, 3'b010: p <= p + multiplicand;
                3'b011:         p <= p + (multiplicand << 1);
                3'b100:         p <= p - (multiplicand << 1);
                3'b101, 3'b110: p <= p - multiplicand;
            endcase

            // Update registers for next iteration
            multiplicand <= multiplicand << 2;
            multiplier <= multiplier >> 2;
            iter_ctr <= iter_ctr + 1;

            // Set ready after 4 iterations
            if (iter_ctr == 3'b100) rdy <= 1'b1;
        end
    end

endmodule
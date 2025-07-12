module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // Extra bit for Booth encoding
    reg [1:0] counter;
    reg prev_lsb;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with proper sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 1'b0};  // Initialize with multiplier + LSB=0
            p <= 16'b0;
            rdy <= 1'b0;
            counter <= 2'b0;
            prev_lsb <= 1'b0;
        end else if (!rdy) begin
            // Booth encoding cases
            case (multiplier[2:0])
                3'b000, 3'b111: p <= p;  // No operation
                3'b001, 3'b010: p <= p + multiplicand;  // +1×M
                3'b011:         p <= p + (multiplicand << 1);  // +2×M
                3'b100:         p <= p - (multiplicand << 1);  // -2×M
                3'b101, 3'b110: p <= p - multiplicand;  // -1×M
            endcase

            // Arithmetic right shift multiplier by 2 bits
            multiplier <= {2{multiplier[8]}, multiplier[8:2]};
            counter <= counter + 1;

            // Set ready after 4 cycles (8 bits / 2 bits per cycle)
            if (counter == 2'b11)
                rdy <= 1'b1;
        end
    end

endmodule
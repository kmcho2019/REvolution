module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // 8 bits + 1 previous LSB
    reg [1:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};  // Sign-extended
            multiplier <= {b, 1'b0};         // Initialize with LSB=0
            p <= 16'b0;
            rdy <= 1'b0;
            counter <= 2'b0;
        end else if (!rdy) begin
            case (multiplier[2:0])
                3'b000, 3'b111: ;  // No operation
                3'b001, 3'b010: p <= p + multiplicand;
                3'b011:         p <= p + (multiplicand << 1);
                3'b100:         p <= p - (multiplicand << 1);
                3'b101, 3'b110: p <= p - multiplicand;
            endcase

            // Arithmetic right shift by 2 bits
            multiplier <= $signed(multiplier) >>> 2;
            counter <= counter + 1;

            // Ready after 4 cycles (8 bits / 2 bits per cycle)
            rdy <= (counter == 2'b11);
        end
    end

endmodule
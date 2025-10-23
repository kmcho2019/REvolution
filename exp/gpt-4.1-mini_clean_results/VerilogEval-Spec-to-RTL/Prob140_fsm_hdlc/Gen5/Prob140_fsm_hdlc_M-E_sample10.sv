module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [7:0] shift_reg;

    // On reset, initialize shift register to zero (previous inputs zero)
    // On each clock, shift in the new bit
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[6:0], in};

            // Detect patterns on bits [7:0]
            // disc: pattern 0111110 detected on bits [7:1] == 7'b0111110
            //    means previous bits ending with 0111110, disc asserted next cycle
            //
            // flag: pattern 01111110 detected on bits [7:0] == 8'b01111110
            //
            // err: 7 or more consecutive ones anywhere in bits [7:1], i.e. bits [7:1] == 7'b1111111
            //      Note: If in stream we see 7 or more ones, err asserted

            // Check disc: shift_reg[7:1] == 7'b0111110
            disc <= (shift_reg[7:1] == 7'b0111110);

            // Check flag: shift_reg[7:0] == 8'b01111110
            flag <= (shift_reg == 8'b01111110);

            // Check err: shift_reg[7:1] == 7'b1111111 (7 consecutive ones)
            // Also consider that 8 ones in a row means err still asserted
            err <= (shift_reg[7:1] == 7'b1111111);
        end
    end

endmodule
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [7:0] shift_reg;

    // Combinational pattern detections from shift_reg plus current input
    // shift_reg contains bits [7:0], with shift_reg[0] = oldest bit, shift_reg[7] = newest bit before shift

    wire disc_detect;
    wire flag_detect;
    wire err_detect;

    // After shifting in current bit, the last 7 bits plus current bit form a window to check patterns.
    // Since shifting happens at posedge clk, we detect patterns in shift_reg concatenated with current input.

    wire [7:0] window = {shift_reg[6:0], in}; // 8-bit sliding window including current input

    // disc = pattern "111110" on last 6 bits: "0111110" pattern means the 6-bit window ends with 111110
    // Specifically, disc on detecting the zero bit stuffed after five ones => pattern bits[5:0] == 111110
    // Check window bits[5:0] == 111110 and bit[6]==0 to correspond to "0111110" (to ensure pattern start)
    // Alternatively, simply detect last 6 bits == 111110 (0b111110 = 62 decimal)
    wire [5:0] last6 = window[5:0];
    wire before_last6 = window[6]; // bit before last6

    assign disc_detect = (last6 == 6'b111110) && (before_last6 == 1'b0);

    // flag = "01111110" full 8-bit pattern = 8'b01111110 = 0x7E
    assign flag_detect = (window == 8'b01111110);

    // err = seven or more consecutive ones anywhere in the last 8 bits after shifting in new bit
    // Check for any substring of 7 ones in window: bits[7:1] or bits[6:0] are all ones
    wire seven_ones_top7 = (window[7:1] == 7'b1111111);
    wire seven_ones_low7 = (window[6:0] == 7'b1111111);
    assign err_detect = seven_ones_top7 || seven_ones_low7;

    // Sequential logic: shift register and registered outputs with one cycle delay after detection
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
            disc      <= 1'b0;
            flag      <= 1'b0;
            err       <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[6:0], in};
            disc      <= disc_detect;
            flag      <= flag_detect;
            err       <= err_detect;
        end
    end

endmodule
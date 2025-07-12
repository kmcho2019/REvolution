module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [7:0] shift_reg;

    // Detection signals (combinational)
    wire disc_w;
    wire flag_w;
    wire err_w;

    // Check patterns in shift_reg + current input pattern after shifting in 'in'
    // Since we shift in 'in' at posedge clk, shift_reg represents bits [7:0] ending with the newest bit.

    // disc: detect zero after five consecutive ones in the bit stream,
    // pattern to detect is 111110 (6 bits), which corresponds to bits [6:1] == 6'b111110
    // We look for this pattern aligned at shift_reg[6:1], discarding the zero at position 1.
    // This zero is the bit to discard, so disc is asserted when shift_reg[6:1]==6'b111110.

    // flag: full 8-bit pattern 01111110 == 8'h7E in shift_reg
    // Indicates frame boundary flag detected.

    // err: detect 7 or more consecutive ones: shift_reg[6:0] == 7'b1111111, or since we have 8 bits,
    // also consider shift_reg[7:1] == 7'b1111111 to catch 7 consecutive ones anywhere.
    // To cover all positions, check if any 7 consecutive bits within shift_reg == 7'b1111111.
    // But since we shift in bit by bit and only keep last 8 bits,
    // check bits [7:1] and [6:0]. For simplicity, check if shift_reg[7:1] or shift_reg[6:0] are all ones.

    // Implementing these detections:
    assign disc_w = (shift_reg[6:1] == 6'b111110);
    assign flag_w = (shift_reg == 8'h7E);
    assign err_w  = (shift_reg[7:1] == 7'b1111111) || (shift_reg[6:0] == 7'b1111111);

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0; // Assume previous input bit is 0 at reset
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[6:0], in}; // shift in input bit

            // Outputs asserted one cycle after detection to meet specification
            disc <= disc_w;
            flag <= flag_w;
            err  <= err_w;
        end
    end

endmodule
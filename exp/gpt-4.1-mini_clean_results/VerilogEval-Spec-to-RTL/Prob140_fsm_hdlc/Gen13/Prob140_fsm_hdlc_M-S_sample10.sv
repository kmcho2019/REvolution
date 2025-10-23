module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [6:1] shift; // holds last 6 input bits; shift[6] oldest, shift[1] newest

    // On reset, initialize shift register to zeros (previous input = 0)
    always @(posedge clk) begin
        if (reset) begin
            shift <= 6'b000000;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            // Shift in new bit
            shift <= {shift[5:1], in};

            // Detect patterns for outputs on next cycle (Moore FSM style)
            // Check number of consecutive ones from shift[6:1] plus current input 'in'
            // For convenience, count consecutive ones by checking bits

            // Check if 7 or more consecutive ones:
            // 7 ones means previous 6 bits all 1 plus current in=1
            // i.e. shift == 6'b111111 and in==1
            err  <= (shift == 6'b111111) && in;

            // disc: last six bits are "111110"
            // i.e. shift == 6'b111110
            // which means five 1's followed by 0, so disc asserted next cycle
            disc <= (shift == 6'b111110);

            // flag: HDLC flag pattern is 0 111110
            // So pattern "0111110" means shift == 6'b0111110
            flag <= (shift == 6'b0111110);
        end
    end

endmodule
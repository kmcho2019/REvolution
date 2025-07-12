module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] shift_reg;  // 7-bit shift register for pattern detection

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Shift in new bit
            shift_reg <= {shift_reg[5:0], in};

            // Detect patterns in parallel
            disc <= (shift_reg[5:0] == 6'b111110) && !in;  // 5 ones followed by 0
            flag <= (shift_reg == 7'b1111110);             // 6 ones followed by 0
            err <= &shift_reg && in;                       // All 7 bits are 1 and next is 1
        end
    end

endmodule
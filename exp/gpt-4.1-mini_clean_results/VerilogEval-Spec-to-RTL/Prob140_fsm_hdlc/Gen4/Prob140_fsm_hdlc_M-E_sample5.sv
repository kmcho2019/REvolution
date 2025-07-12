module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [7:0] shift_reg;

    // Synchronous logic: shift in new bit each cycle
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'd0;
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[6:0], in};

            // Default outputs to zero each cycle (asserted only when detected)
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            // Detect ERROR: 7 or more consecutive ones
            // Check for bits 7:1 = 7 ones OR bits 7:0 = 8 ones
            if ( (shift_reg[7:1] == 7'b111_1111) || (shift_reg == 8'b1111_1111) ) begin
                err <= 1'b1;
            end
            // Else detect FLAG: 0x7E = 01111110
            else if (shift_reg == 8'b0111_1110) begin
                flag <= 1'b1;
            end
            // Else detect DISC: five consecutive ones followed by zero
            // Pattern: bits 7:2 == 6 bits: 111110 (binary)
            else if (shift_reg[7:2] == 6'b111110) begin
                disc <= 1'b1;
            end
            // Otherwise no output asserted
        end
    end

endmodule
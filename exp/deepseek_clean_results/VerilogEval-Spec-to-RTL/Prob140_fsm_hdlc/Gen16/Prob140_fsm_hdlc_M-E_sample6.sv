module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
            {disc, flag, err} <= 3'b0;
        end else begin
            // Shift in new bit
            shift_reg <= {shift_reg[5:0], in};

            // Default outputs
            {disc, flag, err} <= 3'b0;

            // Pattern matching (all conditions checked in parallel)
            case (shift_reg)
                7'b0111110: disc <= 1'b1;  // 5 ones followed by 0
                7'b01111110: flag <= 1'b1; // 6 ones followed by 0
                default: begin
                    if (&shift_reg[6:0]) err <= 1'b1; // All 1s (7 consecutive)
                end
            endcase
        end
    end

endmodule
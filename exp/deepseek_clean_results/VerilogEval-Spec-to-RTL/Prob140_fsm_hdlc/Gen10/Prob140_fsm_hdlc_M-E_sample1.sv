module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] shift_reg;  // Tracks last 7 bits

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Shift in new bit
            shift_reg <= {shift_reg[5:0], in};

            // Default outputs
            disc <= 0;
            flag <= 0;
            err <= 0;

            // Pattern matching (all patterns start with 0 followed by 1s)
            if (!shift_reg[6]) begin
                casez (shift_reg[5:0])
                    6'b111110: disc <= 1;  // 5 1s after 0
                    6'b111111: flag <= 1;  // 6 1s after 0
                endcase
            end

            // Error condition (7 consecutive 1s)
            if (&shift_reg) err <= 1;
        end
    end

endmodule
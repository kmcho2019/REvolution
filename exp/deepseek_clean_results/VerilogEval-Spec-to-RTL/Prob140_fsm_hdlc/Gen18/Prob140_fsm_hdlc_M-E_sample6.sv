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
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Shift in new bit
            shift_reg <= {shift_reg[5:0], in};

            // Pattern detection (combinational)
            casex (shift_reg)
                // Detect 0111110 (discard case)
                7'b0111110: begin
                    disc <= 1;
                    flag <= 0;
                    err <= 0;
                end
                // Detect 01111110 (flag case)
                7'b1111110: begin
                    disc <= 0;
                    flag <= 1;
                    err <= 0;
                end
                // Detect 01111111... (error case)
                7'b1111111: begin
                    disc <= 0;
                    flag <= 0;
                    err <= 1;
                end
                // Default case (no patterns detected)
                default: begin
                    disc <= 0;
                    flag <= 0;
                    err <= 0;
                end
            endcase
        end
    end

endmodule
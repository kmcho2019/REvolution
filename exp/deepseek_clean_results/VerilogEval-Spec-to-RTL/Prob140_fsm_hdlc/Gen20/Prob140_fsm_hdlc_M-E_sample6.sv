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

            // Default outputs
            disc <= 0;
            flag <= 0;
            err <= 0;

            // Pattern matching with priority (error > flag > discard)
            if (shift_reg == 7'b0111111) begin
                err <= 1;
            end else if (shift_reg == 7'b0111110) begin
                flag <= 1;
            end else if (shift_reg[5:0] == 6'b011111 && !in) begin
                disc <= 1;
            end
        end
    end

endmodule
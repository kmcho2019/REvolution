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

            // Pattern matching (all checked in parallel)
            // Check for discard pattern: 0111110 (last 7 bits)
            if (shift_reg == 7'b0111110) begin
                disc <= 1;
            end
            // Check for flag pattern: 01111110 (requires current bit = 0)
            if ({shift_reg, in} == 8'b01111110) begin
                flag <= 1;
            end
            // Check for error pattern: 01111111 (requires current bit = 1)
            if ({shift_reg, in} == 8'b01111111) begin
                err <= 1;
            end
        end
    end

endmodule
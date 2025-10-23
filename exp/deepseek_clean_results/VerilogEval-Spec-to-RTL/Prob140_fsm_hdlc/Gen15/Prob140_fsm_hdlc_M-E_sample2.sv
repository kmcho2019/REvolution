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
            
            // Pattern matching (all conditions checked in parallel)
            if (shift_reg[5:0] == 6'b111110 && in == 0) begin
                disc <= 1;  // 0111110 pattern
            end
            if (shift_reg == 7'b01111110) begin
                flag <= 1;  // 01111110 pattern
            end
            if (shift_reg == 7'b1111111) begin
                err <= 1;   // 7+ consecutive 1s
            end
        end
    end

endmodule
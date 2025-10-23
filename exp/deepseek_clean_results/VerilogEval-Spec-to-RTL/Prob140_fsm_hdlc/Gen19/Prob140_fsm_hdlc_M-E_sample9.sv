module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] shift_reg;  // 7-bit shift register to track last 7 inputs

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Shift in new bit
            shift_reg <= {shift_reg[5:0], in};

            // Pattern detection (registered outputs)
            disc <= (shift_reg == 7'b0111110);
            flag <= (shift_reg == 7'b01111110);
            
            // Error detection (7 or more consecutive 1s)
            err <= &shift_reg;  // All bits are 1
        end
    end

endmodule
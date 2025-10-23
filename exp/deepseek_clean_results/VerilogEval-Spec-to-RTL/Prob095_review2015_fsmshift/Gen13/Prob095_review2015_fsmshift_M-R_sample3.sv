module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [3:0] shift_reg = 4'b0000;  // Initialize to all zeros

    assign shift_ena = |shift_reg;  // OR of all bits

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b1111;   // Initialize to all ones on reset
        end else if (shift_ena) begin  // Only shift if not all zeros
            shift_reg <= {shift_reg[2:0], 1'b0};
        end
    end

endmodule
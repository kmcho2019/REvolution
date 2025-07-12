module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [3:0] shift_reg;

    assign shift_ena = shift_reg[3];

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b1111;
        end else if (|shift_reg) begin  // Only shift if not all zeros
            shift_reg <= {shift_reg[2:0], 1'b0};
        end
    end

endmodule
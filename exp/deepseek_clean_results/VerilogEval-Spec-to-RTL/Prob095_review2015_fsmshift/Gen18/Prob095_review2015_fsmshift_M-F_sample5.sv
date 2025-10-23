module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [3:0] shift_reg;

    assign shift_ena = shift_reg[3];

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b1110;  // Changed from 1111 to 1110 for exact 4 cycles
        end else if (|shift_reg) begin
            shift_reg <= {shift_reg[2:0], 1'b0};
        end
    end

endmodule
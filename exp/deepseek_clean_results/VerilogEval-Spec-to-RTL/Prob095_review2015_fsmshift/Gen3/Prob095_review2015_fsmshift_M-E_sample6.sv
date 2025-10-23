module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0001;
        end else if (|shift_reg) begin
            shift_reg <= {shift_reg[2:0], 1'b0};
        end
    end

    assign shift_ena = |shift_reg;

endmodule
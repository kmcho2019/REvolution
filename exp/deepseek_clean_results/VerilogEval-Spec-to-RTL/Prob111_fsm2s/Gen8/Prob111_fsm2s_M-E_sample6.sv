module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg [1:0] shift_reg;  // "01" = OFF, "10" = ON

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 2'b01;  // Reset to OFF state
        end else begin
            case (shift_reg)
                2'b01: shift_reg <= j ? 2'b10 : {shift_reg[0], shift_reg[1]};
                2'b10: shift_reg <= k ? 2'b01 : {shift_reg[0], shift_reg[1]};
                default: shift_reg <= 2'b01;  // Handle invalid states
            endcase
        end
    end

    assign out = shift_reg[1];  // MSB indicates ON/OFF state

endmodule
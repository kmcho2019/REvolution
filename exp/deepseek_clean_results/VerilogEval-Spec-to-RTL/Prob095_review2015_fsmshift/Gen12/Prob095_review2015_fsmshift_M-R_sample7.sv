module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [3:0] shift_reg;

    assign shift_ena = |shift_reg;  // OR of all bits

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b1110;  // Initialize to assert immediately
        end else begin
            shift_reg <= {shift_reg[2:0], 1'b0};  // Shift right with 0 input
        end
    end

endmodule
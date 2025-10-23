module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b1111;
        end else begin
            shift_reg <= shift_reg >> 1;
        end
    end

    assign shift_ena = |shift_reg;  // OR of all bits (equivalent to shift_reg[0])

endmodule
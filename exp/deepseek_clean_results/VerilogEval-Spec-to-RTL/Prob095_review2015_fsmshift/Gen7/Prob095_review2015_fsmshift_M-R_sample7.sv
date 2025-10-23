module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    wire [3:0] next_shift = reset ? 4'b1111 : {shift_reg[2:0], 1'b0};
    reg [3:0] shift_reg;

    always @(posedge clk) begin
        shift_reg <= next_shift;
    end

    assign shift_ena = |shift_reg;  // OR of all bits

endmodule
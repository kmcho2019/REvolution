module TopModule (
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg;
assign state = state_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01;
    end else if (train_valid) begin
        case ({train_taken, state_reg})
            3'b1_00, 3'b1_01, 3'b1_10: state_reg <= (state_reg == 2'b11) ? 2'b11 : state_reg + 1'b1;
            3'b0_01, 3'b0_10, 3'b0_11: state_reg <= (state_reg == 2'b00) ? 2'b00 : state_reg - 1'b1;
            default: state_reg <= state_reg;
        endcase
    end else begin
        state_reg <= state_reg;
    end
end

endmodule
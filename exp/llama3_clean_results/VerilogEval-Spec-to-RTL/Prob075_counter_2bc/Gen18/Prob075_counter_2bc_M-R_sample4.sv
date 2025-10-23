module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01;
    end else begin
        case ({train_valid, train_taken})
            2'b00: state_reg <= state_reg;
            2'b01: state_reg <= (state_reg == 2'b00)? 2'b00 : state_reg - 1;
            2'b10: state_reg <= (state_reg == 2'b11)? 2'b11 : state_reg + 1;
            2'b11: state_reg <= (state_reg == 2'b11)? 2'b11 : state_reg + 1;
            default: state_reg <= state_reg;
        endcase
    end
end

assign state = state_reg;

endmodule
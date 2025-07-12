module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;
reg [1:0] next_state;

always @(*) begin
    case(state_reg)
        2'b00: next_state = (train_valid && train_taken)? 2'b01 : (train_valid && !train_taken)? 2'b00 : 2'b00;
        2'b01: next_state = (train_valid && train_taken)? 2'b10 : (train_valid && !train_taken)? 2'b00 : 2'b01;
        2'b10: next_state = (train_valid && train_taken)? 2'b11 : (train_valid && !train_taken)? 2'b01 : 2'b10;
        2'b11: next_state = (train_valid && train_taken)? 2'b11 : (train_valid && !train_taken)? 2'b10 : 2'b11;
        default: next_state = 2'b01;
    endcase
end

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state_reg <= 2'b01;
    end else begin
        state_reg <= next_state;
    end
end

assign state = state_reg;

endmodule
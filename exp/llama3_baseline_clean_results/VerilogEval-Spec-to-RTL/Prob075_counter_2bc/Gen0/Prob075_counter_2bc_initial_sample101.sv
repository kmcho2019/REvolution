module TopModule(
    input         clk,
    input         areset,
    input         train_valid,
    input         train_taken,
    output [1:0]  state
);

reg [1:0] state_reg;
reg [1:0] state_next;

always @(*) begin
    case ({train_valid, train_taken})
        2'b11: state_next = (state_reg == 2'b11) ? 2'b11 : state_reg + 1'b1; // increment, saturate at 3
        2'b10: state_next = (state_reg == 2'b00) ? 2'b00 : state_reg - 1'b1; // decrement, saturate at 0
        default: state_next = state_reg; // hold current value when not training
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // asynchronous reset to weakly not-taken
    end else begin
        state_reg <= state_next;
    end
end

assign state = state_reg;

endmodule
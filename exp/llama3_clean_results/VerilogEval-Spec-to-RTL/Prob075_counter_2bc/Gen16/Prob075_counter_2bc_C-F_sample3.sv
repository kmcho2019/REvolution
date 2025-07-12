module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state_reg <= 2'b01; // Reset to weakly not-taken state
    end else begin
        case ({train_valid, train_taken})
            2'b11: state_reg <= (state_reg == 2'b11) ? 2'b11 : state_reg + 1; // Increment if not at max
            2'b10: state_reg <= (state_reg == 2'b00) ? 2'b00 : state_reg - 1; // Decrement if not at min
            default: state_reg <= state_reg; // Hold state if not training
        endcase
    end
end

assign state = state_reg; // Output the current state

endmodule
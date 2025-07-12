module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Reset to weakly not-taken state
    end else begin
        case ({train_valid, train_taken})
            2'b11: begin // Increment counter when train_valid = 1 and train_taken = 1
                if (state_reg == 2'b11) begin // Saturate at maximum value
                    state_reg <= 2'b11;
                end else begin
                    state_reg <= state_reg + 1'b1;
                end
            end
            2'b10: begin // Decrement counter when train_valid = 1 and train_taken = 0
                if (state_reg == 2'b00) begin // Saturate at minimum value
                    state_reg <= 2'b00;
                end else begin
                    state_reg <= state_reg - 1'b1;
                end
            end
            default: begin // Keep counter unchanged when not training
                state_reg <= state_reg;
            end
        endcase
    end
end

assign state = state_reg;

endmodule
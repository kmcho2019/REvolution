module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
reg [1:0] state_reg;

always @(posedge clk) begin
    case (state_reg)
        2'b00: // IDLE state
            begin
                if (shift_ena) begin
                    state_reg <= 2'b01; // Transition to SHIFT state
                end else if (count_ena) begin
                    state_reg <= 2'b10; // Transition to COUNT state
                end
            end
        2'b01: // SHIFT state
            begin
                q_reg <= {data, q_reg[3:1]};
                state_reg <= 2'b00; // Transition back to IDLE state
            end
        2'b10: // COUNT state
            begin
                if (q_reg!= 4'b0) begin
                    q_reg <= q_reg - 1;
                end
                state_reg <= 2'b00; // Transition back to IDLE state
            end
        default: begin
            state_reg <= 2'b00; // Default to IDLE state
        end
    endcase
end

assign q = q_reg;

endmodule
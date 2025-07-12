module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
reg [1:0] state_reg; // 2-bit state register for FSM
parameter IDLE = 2'b00, SHIFT = 2'b01, DECREMENT = 2'b10;

always @(posedge clk) begin
    case (state_reg)
        IDLE: begin
            if (shift_ena) begin
                state_reg <= SHIFT;
                q_reg <= {q_reg[2:0], data};
            end else if (count_ena) begin
                state_reg <= DECREMENT;
                q_reg <= q_reg - 1;
            end else begin
                state_reg <= IDLE;
            end
        end
        SHIFT: begin
            if (!shift_ena) begin
                state_reg <= IDLE;
            end else begin
                q_reg <= {q_reg[2:0], data};
            end
        end
        DECREMENT: begin
            if (!count_ena) begin
                state_reg <= IDLE;
            end else begin
                q_reg <= q_reg - 1;
            end
        end
    endcase
end

assign q = q_reg;

endmodule
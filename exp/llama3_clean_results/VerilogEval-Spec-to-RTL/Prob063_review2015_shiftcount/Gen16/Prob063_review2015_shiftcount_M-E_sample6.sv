module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
reg [1:0] state; // 2 states: shift (0), count (1)

always @(posedge clk) begin
    case(state)
        2'b00: // shift state
            begin
                if (shift_ena) begin
                    q_reg <= {data, q_reg[3:1]};
                end
                if (count_ena) begin
                    state <= 2'b01; // transition to count state
                end
            end
        2'b01: // count state
            begin
                if (count_ena) begin
                    if (q_reg == 4'b0) begin
                        q_reg <= 4'b1111; // wrap around to 4'b1111 when q_reg is 0
                    end else begin
                        q_reg <= q_reg - 1;
                    end
                end
                if (shift_ena) begin
                    state <= 2'b00; // transition to shift state
                end
            end
        default:
            state <= 2'b00; // default to shift state
    endcase
end

assign q = q_reg;

endmodule
module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 0;
reg [3:0] temp_reg = 0;
reg [1:0] state = 0; // 0: idle, 1: shift, 2: count

always @(posedge clk) begin
    case (state)
        0: begin // idle
            if (shift_ena) begin
                state <= 1;
                temp_reg <= {data, q_reg[3:1]};
            end else if (count_ena) begin
                state <= 2;
                if (q_reg == 0) begin
                    temp_reg <= 0; // Saturate at 0
                end else begin
                    temp_reg <= q_reg - 1;
                end
            end else begin
                state <= 0;
                temp_reg <= q_reg;
            end
        end
        1: begin // shift
            state <= 0;
            q_reg <= temp_reg;
        end
        2: begin // count
            state <= 0;
            q_reg <= temp_reg;
        end
    endcase
end

assign q = q_reg;

endmodule
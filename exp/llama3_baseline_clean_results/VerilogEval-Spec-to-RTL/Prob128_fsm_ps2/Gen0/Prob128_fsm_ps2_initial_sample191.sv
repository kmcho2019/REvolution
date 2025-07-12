module TopModule(
    input               clk,
    input               reset,
    input       [7:0]   in,
    output              done
);

reg   [1:0] state; // 00: IDLE, 01: BYTE1, 10: BYTE2, 11: BYTE3
reg           done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // BYTE1
                end
            end
            2'b01: begin // BYTE1
                state <= 2'b10; // BYTE2
            end
            2'b10: begin // BYTE2
                state <= 2'b11; // BYTE3
            end
            2'b11: begin // BYTE3
                done_reg <= 1'b1;
                state <= 2'b00; // IDLE
            end
            default: state <= 2'b00; // IDLE
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 1'b0;
    end else begin
        done <= done_reg;
        done_reg <= 1'b0;
    end
end

endmodule
module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [2:0] state;
reg [1:0] seq_state;
reg [2:0] shift_cnt;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        seq_state <= 2'b00;
        shift_cnt <= 3'b000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE
                case (seq_state)
                    2'b00: begin
                        if (data) begin
                            seq_state <= 2'b01;
                        end
                    end
                    2'b01: begin
                        if (~data) begin
                            seq_state <= 2'b10;
                        end else begin
                            seq_state <= 2'b00;
                        end
                    end
                    2'b10: begin
                        if (data) begin
                            seq_state <= 2'b11;
                        end else begin
                            seq_state <= 2'b00;
                        end
                    end
                    2'b11: begin
                        if (~data) begin
                            state <= 3'b001;
                            seq_state <= 2'b00;
                        end else begin
                            seq_state <= 2'b00;
                        end
                    end
                endcase
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            3'b001: begin // SHIFTING
                shift_ena <= 1'b1;
                shift_cnt <= shift_cnt + 1'b1;
                if (shift_cnt == 3'b100) begin
                    state <= 3'b010;
                    shift_cnt <= 3'b000;
                end
                counting <= 1'b0;
                done <= 1'b0;
            end
            3'b010: begin // COUNTING
                shift_ena <= 1'b0;
                counting <= 1'b1;
                if (done_counting) begin
                    state <= 3'b011;
                end
                done <= 1'b0;
            end
            3'b011: begin // DONE
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
                if (ack) begin
                    state <= 3'b000;
                end
            end
        endcase
    end
end

endmodule
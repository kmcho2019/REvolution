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

    enum logic [1:0] {IDLE, SHIFT, COUNTING, DONE} state, next_state;
    reg [3:0] shift_counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_counter <= 0;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    if (shift_counter == 4'b1101) begin
                        next_state <= SHIFT;
                        shift_counter <= 0;
                    end else if (data == 1'b1 && shift_counter == 4'b110) begin
                        shift_counter <= {1'b1, shift_counter[2:0]};
                    end else if (data == 1'b0 && shift_counter == 4'b11) begin
                        shift_counter <= {1'b0, shift_counter[2:0]};
                    end else if (data == 1'b1 && shift_counter == 4'b1) begin
                        shift_counter <= {1'b1, shift_counter[2:0]};
                    end else if (data == 1'b0 && shift_counter == 4'b10) begin
                        shift_counter <= {1'b0, shift_counter[2:0]};
                    end else if (data == 1'b1 && shift_counter == 4'b0) begin
                        shift_counter <= {1'b1, shift_counter[2:0]};
                    end else begin
                        shift_counter <= {data, shift_counter[2:0]};
                    end
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                end
                SHIFT: begin
                    shift_counter <= shift_counter + 1;
                    if (shift_counter == 4) begin
                        next_state <= COUNTING;
                    end else begin
                        next_state <= SHIFT;
                    end
                    shift_ena <= 1;
                    counting <= 0;
                    done <= 0;
                end
                COUNTING: begin
                    if (done_counting) begin
                        next_state <= DONE;
                    end else begin
                        next_state <= COUNTING;
                    end
                    shift_ena <= 0;
                    counting <= 1;
                    done <= 0;
                end
                DONE: begin
                    if (ack) begin
                        next_state <= IDLE;
                    end else begin
                        next_state <= DONE;
                    end
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 1;
                end
                default: begin
                    next_state <= IDLE;
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                end
            endcase
        end
    end
endmodule
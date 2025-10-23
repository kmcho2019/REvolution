module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state;
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter WAIT_DONE = 2'b11;
reg [3:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin // start pattern detection
                    if (shift_count == 0) begin
                        if (data == 1'b1) begin
                            shift_count <= shift_count + 1;
                        end
                    end
                    else if (shift_count == 1) begin
                        if (data == 1'b0) begin
                            shift_count <= shift_count + 1;
                        end
                        else begin
                            shift_count <= 0;
                        end
                    end
                    else if (shift_count == 2) begin
                        if (data == 1'b1) begin
                            shift_count <= shift_count + 1;
                        end
                        else begin
                            shift_count <= 0;
                        end
                    end
                    else if (shift_count == 3) begin
                        if (data == 1'b0) begin
                            shift_count <= 0;
                            state <= SHIFT;
                        end
                        else begin
                            shift_count <= 0;
                        end
                    end
                end
                else begin
                    shift_count <= 0;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            SHIFT: begin
                shift_ena <= 1;
                if (shift_count == 4) begin
                    shift_ena <= 0;
                    shift_count <= 0;
                    state <= COUNT;
                end
                else begin
                    shift_count <= shift_count + 1;
                end
                counting <= 0;
                done <= 0;
            end
            COUNT: begin
                counting <= 1;
                shift_ena <= 0;
                if (done_counting) begin
                    counting <= 0;
                    state <= WAIT_DONE;
                end
                done <= 0;
            end
            WAIT_DONE: begin
                done <= 1;
                if (ack) begin
                    done <= 0;
                    state <= IDLE;
                end
                shift_ena <= 0;
                counting <= 0;
            end
            default: begin
                state <= IDLE;
                shift_count <= 0;
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
        endcase
    end
end

endmodule
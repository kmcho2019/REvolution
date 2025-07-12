module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // Define states
    typedef enum logic [2:0] {
        IDLE,
        S1,
        S11,
        S110,
        SHIFT,
        COUNT,
        DONE
    } state_t;

    reg [2:0] state, next_state;
    reg [1:0] shift_count;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'b0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default outputs
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;

            case (state)
                IDLE: begin
                    if (data == 1'b1)
                        next_state <= S1;
                    else
                        next_state <= IDLE;
                end
                S1: begin
                    if (data == 1'b1)
                        next_state <= S11;
                    else
                        next_state <= IDLE;
                end
                S11: begin
                    if (data == 1'b0)
                        next_state <= S110;
                    else
                        next_state <= IDLE;
                end
                S110: begin
                    if (data == 1'b1) begin
                        next_state <= SHIFT;
                        shift_count <= 2'b0;
                    end else
                        next_state <= IDLE;
                end
                SHIFT: begin
                    shift_ena <= 1'b1;
                    if (shift_count == 2'b11)
                        next_state <= COUNT;
                    else begin
                        next_state <= SHIFT;
                        shift_count <= shift_count + 1;
                    end
                end
                COUNT: begin
                    counting <= 1'b1;
                    if (done_counting)
                        next_state <= DONE;
                    else
                        next_state <= COUNT;
                end
                DONE: begin
                    done <= 1'b1;
                    if (ack)
                        next_state <= IDLE;
                    else
                        next_state <= DONE;
                end
                default: next_state <= IDLE;
            endcase
        end
    end

endmodule
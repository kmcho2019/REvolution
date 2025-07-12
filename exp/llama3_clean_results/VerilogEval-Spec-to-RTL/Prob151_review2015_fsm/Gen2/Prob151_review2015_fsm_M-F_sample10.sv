module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

typedef enum logic [2:0] {
    IDLE = 3'b000,
    SHIFT = 3'b001,
    COUNT = 3'b010,
    DONE = 3'b011,
    ACK = 3'b100
} state_t;

state_t state, next_state;
reg [3:0] sequence;
reg [1:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        sequence <= 0;
        shift_count <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    sequence <= {sequence[2:0], 1'b1};
                end else begin
                    sequence <= {sequence[2:0], 1'b0};
                end
                if (sequence == 4'b1101) begin
                    state <= SHIFT;
                    sequence <= 0;
                    shift_count <= 0;
                end
            end
            SHIFT: begin
                shift_ena <= 1;
                if (data) begin
                    sequence <= {sequence[2:0], 1'b1};
                end else begin
                    sequence <= {sequence[2:0], 1'b0};
                end
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= COUNT;
                    shift_ena <= 0;
                end
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) begin
                    state <= DONE;
                end
            end
            DONE: begin
                done <= 1;
                if (ack) begin
                    state <= IDLE;
                    counting <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule
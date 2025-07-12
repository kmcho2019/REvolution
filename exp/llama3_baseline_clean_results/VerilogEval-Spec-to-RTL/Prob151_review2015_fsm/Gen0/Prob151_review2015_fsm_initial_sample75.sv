module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

// Define states
enum logic [2:0] {
    IDLE,
    MATCH1,
    MATCH2,
    MATCH3,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

// Counter to keep track of shifted bits
logic [1:0] shift_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        if (state == SHIFT) begin
            shift_count <= shift_count + 1;
        end else begin
            shift_count <= 0;
        end
        if (state == SHIFT) begin
            shift_ena <= 1;
        end else begin
            shift_ena <= 0;
        end
        if (state == COUNT) begin
            counting <= 1;
        end else begin
            counting <= 0;
        end
        if (state == DONE) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

always_comb begin
    case (state)
        IDLE: begin
            if (data == 1) begin
                next_state = MATCH1;
            end else begin
                next_state = IDLE;
            end
        end
        MATCH1: begin
            if (data == 1) begin
                next_state = MATCH2;
            end else begin
                next_state = IDLE;
            end
        end
        MATCH2: begin
            if (data == 0) begin
                next_state = MATCH3;
            end else begin
                next_state = IDLE;
            end
        end
        MATCH3: begin
            if (data == 1) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 3) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (done_counting == 1) begin
                next_state = DONE;
            end else begin
                next_state = COUNT;
            end
        end
        DONE: begin
            if (ack == 1) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule
module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

// Define the states
enum logic [1:0] {
    IDLE,
    START,
    DATA,
    STOP
} state, next_state;

logic [2:0] data_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_count <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        if (state == DATA) begin
            data_count <= data_count + 1;
        end else begin
            data_count <= 0;
        end
        done <= (state == STOP && in == 1);
    end
end

always_comb begin
    case (state)
        IDLE: begin
            if (!in) begin
                next_state = START;
            end else begin
                next_state = IDLE;
            end
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (data_count == 7) begin
                next_state = STOP;
            end else begin
                next_state = DATA;
            end
        end
        STOP: begin
            if (in) begin
                next_state = IDLE;
            end else begin
                next_state = STOP;
            end
        end
    endcase
end

endmodule
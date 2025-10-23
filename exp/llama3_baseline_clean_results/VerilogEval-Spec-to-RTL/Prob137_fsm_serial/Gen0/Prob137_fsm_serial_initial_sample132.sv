module TopModule (
    input         clk,
    input         reset,
    input         in,
    output        done
);

// Define the states
enum logic [2:0] {
    IDLE,
    RECEIVE_DATA,
    RECEIVE_STOP,
    DONE,
    INVALID_STOP
} state, next_state;

// Data storage
logic [7:0] data;
logic [2:0] data_counter;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        data_counter <= 3'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                data_counter <= 3'b0;
                data <= 8'b0;
            end
            RECEIVE_DATA: begin
                data_counter <= data_counter + 1'b1;
                data <= {data[6:0], in};
            end
            RECEIVE_STOP: begin
                done <= 1'b0;
            end
            DONE: begin
                data <= 8'b0;
                data_counter <= 3'b0;
            end
            INVALID_STOP: begin
                data <= 8'b0;
                data_counter <= 3'b0;
            end
        endcase
        done <= (state == DONE) ? 1'b1 : 1'b0;
    end
end

always_comb begin
    case (state)
        IDLE: begin
            if (in == 1'b0) begin
                next_state = RECEIVE_DATA;
            end else begin
                next_state = IDLE;
            end
        end
        RECEIVE_DATA: begin
            if (data_counter == 8) begin
                next_state = RECEIVE_STOP;
            end else begin
                next_state = RECEIVE_DATA;
            end
        end
        RECEIVE_STOP: begin
            if (in == 1'b1) begin
                next_state = DONE;
            end else begin
                next_state = INVALID_STOP;
            end
        end
        DONE: begin
            next_state = IDLE;
        end
        INVALID_STOP: begin
            if (in == 1'b1) begin
                next_state = IDLE;
            end else begin
                next_state = INVALID_STOP;
            end
        end
    endcase
end

endmodule
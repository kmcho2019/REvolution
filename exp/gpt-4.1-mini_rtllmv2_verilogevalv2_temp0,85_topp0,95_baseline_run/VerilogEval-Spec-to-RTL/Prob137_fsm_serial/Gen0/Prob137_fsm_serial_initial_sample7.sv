module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE  = 3'd0,
        START = 3'd1,
        DATA  = 3'd2,
        STOP  = 3'd3,
        ERROR = 3'd4
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] bit_cnt; // counts 0 to 7 for 8 data bits

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            if (state == DATA) begin
                bit_cnt <= bit_cnt + 1'b1;
            end else begin
                bit_cnt <= 3'd0;
            end

            // done pulse generation
            if (state == STOP && in == 1'b1) begin
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                // After detecting start bit, move to DATA
                next_state = DATA;
            end
            DATA: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            ERROR: begin
                // wait for stop bit (1) to return to IDLE
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
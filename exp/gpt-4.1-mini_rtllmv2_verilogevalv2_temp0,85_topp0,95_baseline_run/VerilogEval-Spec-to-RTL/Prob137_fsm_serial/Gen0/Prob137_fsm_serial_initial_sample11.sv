module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3,
        WAIT_STOP = 3'd4
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] bit_count; // counts 0 to 7 for 8 data bits
    reg [7:0] data_reg;

    // Sequential logic for state transitions, counters, and done signal
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                end
                START: begin
                    // no counter increment here
                end
                DATA: begin
                    data_reg <= {in, data_reg[7:1]}; // shift in LSB first
                    bit_count <= bit_count + 1'b1;
                end
                STOP: begin
                    // no counter increment
                end
                WAIT_STOP: begin
                    // no counter increment
                end
            endcase
        end
    end

    // Combinational logic for next state and done
    always @(*) begin
        next_state = state;
        done = 1'b0;

        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE; // false start, go back to idle
            end
            DATA: begin
                if (bit_count == 3'd7) // last data bit received
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1) begin
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
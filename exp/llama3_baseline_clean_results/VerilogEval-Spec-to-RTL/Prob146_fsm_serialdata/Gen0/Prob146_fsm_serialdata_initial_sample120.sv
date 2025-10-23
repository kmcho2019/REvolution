module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

// Enumerated type for the FSM states
enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP,
    ERROR
} state, next_state;

// Internal register to store the received data
logic [7:0] data_reg;

// Internal counter to keep track of the number of data bits received
logic [2:0] data_cnt;

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (in == 1'b0) begin
                next_state = START;
            end else begin
                next_state = IDLE;
            end
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (data_cnt == 8'd7) begin
                next_state = STOP;
            end else begin
                next_state = DATA;
            end
        end
        STOP: begin
            if (in == 1'b1) begin
                next_state = IDLE;
            end else begin
                next_state = ERROR;
            end
        end
        ERROR: begin
            if (in == 1'b1) begin
                next_state = IDLE;
            end else begin
                next_state = ERROR;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_reg <= 8'd0;
        data_cnt <= 3'd0;
        out_byte <= 8'd0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                state <= next_state;
            end
            START: begin
                state <= next_state;
            end
            DATA: begin
                data_reg <= {data_reg[6:0], in};
                data_cnt <= data_cnt + 1'd1;
                state <= next_state;
            end
            STOP: begin
                out_byte <= data_reg;
                done <= 1'b1;
                state <= next_state;
            end
            ERROR: begin
                state <= next_state;
            end
            default: state <= IDLE;
        endcase
    end
end

// Synchronous reset for done signal
always_ff @(posedge clk) begin
    if (reset) begin
        done <= 1'b0;
    end else if (state == STOP) begin
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

endmodule
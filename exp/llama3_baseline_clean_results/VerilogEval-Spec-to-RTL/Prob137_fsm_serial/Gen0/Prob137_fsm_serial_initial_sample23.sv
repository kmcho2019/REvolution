module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

    // Define the states
    typedef enum logic [1:0] {
        IDLE,
        DATA,
        STOP,
        ERROR
    } state_t;

    // Define the current state and next state
    state_t current_state, next_state;
    reg [2:0] data_counter;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            data_counter <= 0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    if (~in) begin
                        next_state <= DATA;
                        data_counter <= 1;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                DATA: begin
                    data_counter <= data_counter + 1;
                    if (data_counter == 8) begin
                        next_state <= STOP;
                    end else begin
                        next_state <= DATA;
                    end
                end
                STOP: begin
                    if (in) begin
                        next_state <= IDLE;
                        data_counter <= 0;
                        done <= 1'b1;
                    end else begin
                        next_state <= ERROR;
                    end
                end
                ERROR: begin
                    if (in) begin
                        next_state <= IDLE;
                        data_counter <= 0;
                    end else begin
                        next_state <= ERROR;
                    end
                end
            endcase
        end
    end

    // Combinational logic for output
    always @(*) begin
        if (current_state == STOP && in) begin
            done = 1'b1;
        end else begin
            done = 1'b0;
        end
    end

endmodule
module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    reg [3:0] state; // 0: IDLE, 1: READ_DELAY, 2: COUNTING, 3: DONE_WAIT
    reg [3:0] delay;
    reg [3:0] current_count;
    reg [9:0] counter; // For counting 1000 clock cycles
    reg [3:0] pattern_register;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0; // Reset to IDLE
            done <= 0;
            counting <= 0;
            pattern_register <= 0;
            current_count <= 0;
            counter <= 0;
        end else begin
            case (state)
                0: begin // IDLE
                    if (data == 1) begin
                        pattern_register <= {pattern_register[2:0], 1};
                        if (pattern_register == 4'b1101) begin
                            state <= 1; // Transition to READ_DELAY
                            pattern_register <= 0;
                        end
                    end else begin
                        pattern_register <= {pattern_register[2:0], 0};
                    end
                end
                1: begin // READ_DELAY
                    delay <= {delay[2:0], data};
                    if (delay[0] == 1'b1) begin
                        state <= 2; // Transition to COUNTING
                        current_count <= delay + 1;
                        counter <= 10'd999; // Initialize counter for 1000 cycles
                    end
                end
                2: begin // COUNTING
                    counting <= 1;
                    if (counter == 0) begin
                        counter <= 10'd999; // Reset counter for next 1000 cycles
                        if (current_count > 0) begin
                            current_count <= current_count - 1;
                            count <= current_count;
                        end else begin
                            state <= 3; // Transition to DONE_WAIT
                            done <= 1;
                            counting <= 0;
                        end
                    end else begin
                        counter <= counter - 1;
                        count <= current_count;
                    end
                end
                3: begin // DONE_WAIT
                    if (ack == 1) begin
                        state <= 0; // Transition back to IDLE
                        done <= 0;
                    end
                end
            endcase
        end
    end

endmodule
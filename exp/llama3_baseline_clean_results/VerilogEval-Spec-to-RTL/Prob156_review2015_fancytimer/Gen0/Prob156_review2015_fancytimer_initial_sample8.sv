module TopModule(
    input         clk,
    input         reset,
    input         data,
    output [3:0]  count,
    output        counting,
    output        done,
    input         ack
);

    reg [3:0]     state; // 0: IDLE, 1: DELAY_READ, 2: COUNTING, 3: DONE
    reg [3:0]     delay; // stores the delay duration
    reg [3:0]     remaining_time; // stores the remaining time
    reg [3:0]     counter; // counter for counting
    reg [3:0]     shift_reg; // shift register for delay bits
    reg           shift_bit; // flag to shift in delay bits
    reg           counting_out; // output counting signal
    reg           done_out; // output done signal

    always @ (posedge clk) begin
        if (reset) begin
            state <= 0; // reset to IDLE state
            delay <= 0;
            remaining_time <= 0;
            counter <= 0;
            shift_reg <= 0;
            shift_bit <= 0;
            counting_out <= 0;
            done_out <= 0;
        end else begin
            case (state)
                0: begin // IDLE state
                    if (data == 1 && shift_reg == 4'b110) begin
                        shift_reg <= {shift_reg, 1}; // shift in the 4th bit
                        state <= 1; // transition to DELAY_READ state
                    end else if (data == 1 && shift_reg == 4'b11) begin
                        shift_reg <= {shift_reg, 1}; // shift in the 3rd bit
                    end else if (data == 0 && shift_reg == 4'b1) begin
                        shift_reg <= {shift_reg, 0}; // shift in the 2nd bit
                    end else if (data == 1) begin
                        shift_reg <= {shift_reg, 1}; // shift in the 1st bit
                    end else begin
                        shift_reg <= 0; // reset shift register
                    end
                end
                1: begin // DELAY_READ state
                    if (shift_bit == 1'b1) begin
                        delay <= {shift_reg[3:1], data}; // store the delay duration
                        state <= 2; // transition to COUNTING state
                        counter <= 0;
                        remaining_time <= delay;
                        counting_out <= 1'b1;
                        shift_bit <= 1'b0;
                    end else begin
                        shift_reg <= {shift_reg, data}; // shift in the next delay bit
                        if (shift_reg == 4'b1111) begin
                            shift_bit <= 1'b1; // set flag to shift in the last bit
                        end
                    end
                end
                2: begin // COUNTING state
                    if (counter == 1000) begin
                        counter <= 0;
                        if (remaining_time > 0) begin
                            remaining_time <= remaining_time - 1;
                        end else begin
                            state <= 3; // transition to DONE state
                            counting_out <= 1'b0;
                        end
                    end else begin
                        counter <= counter + 1;
                    end
                end
                3: begin // DONE state
                    if (ack == 1'b1) begin
                        state <= 0; // transition to IDLE state
                        done_out <= 1'b0;
                    end
                end
            endcase
        end
    end

    assign count = remaining_time;
    assign counting = counting_out;
    assign done = done_out;

endmodule
module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] delay; // delay value
reg [3:0] current_count; // current count value
reg [9:0] counter; // counter for counting down the timer
reg [3:0] shift_reg; // shift register for shifting in delay bits
reg shift_flag; // flag to indicate if shifting is complete
reg start_flag; // flag to indicate if the input pattern is detected
reg [3:0] pattern; // input pattern register

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        delay <= 0;
        current_count <= 0;
        counter <= 0;
        shift_reg <= 0;
        shift_flag <= 0;
        start_flag <= 0;
        pattern <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        start_flag <= 1;
                        state <= 1; // SHIFT
                    end else begin
                        pattern <= {pattern[2:0], data};
                    end
                end else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            1: begin // SHIFT
                shift_reg <= {shift_reg[2:0], data};
                if (shift_flag == 1'b0) begin
                    if (shift_reg == 4'b1000) begin
                        delay <= shift_reg;
                        state <= 2; // COUNT
                        counter <= (delay + 1) * 10'd1000;
                        current_count <= delay;
                        counting <= 1;
                    end else begin
                        shift_flag <= 1;
                    end
                end else begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1000) begin
                        delay <= shift_reg;
                        state <= 2; // COUNT
                        counter <= (delay + 1) * 10'd1000;
                        current_count <= delay;
                        counting <= 1;
                    end
                end
            end
            2: begin // COUNT
                if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        current_count <= current_count - 1;
                    end
                end else begin
                    state <= 3; // DONE
                    counting <= 0;
                    done <= 1;
                end
            end
            3: begin // DONE
                if (ack == 1'b1) begin
                    state <= 0; // IDLE
                    done <= 0;
                    start_flag <= 0;
                end
            end
        endcase
    end
end

assign count = current_count;

endmodule
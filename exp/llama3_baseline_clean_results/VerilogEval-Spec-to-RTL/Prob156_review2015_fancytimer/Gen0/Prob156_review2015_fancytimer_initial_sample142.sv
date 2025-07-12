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
reg [3:0] shift_reg; // to shift in the next 4 bits
reg [3:0] delay; // to store the delay value
reg [9:0] count_down; // to count down from (delay + 1) * 1000 clock cycles
reg [3:0] remaining_time; // to count the remaining time
reg start_count; // to start counting

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        count_down <= 0;
        remaining_time <= 0;
        start_count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data) begin // first bit of the pattern
                    state <= 1; // wait for the rest of the pattern
                end else begin
                    state <= 0; // stay in IDLE
                end
            end
            1: begin // wait for the rest of the pattern
                if (data) begin // second bit of the pattern
                    state <= 2; // wait for the third bit
                end else begin
                    state <= 0; // pattern not found, go back to IDLE
                end
            end
            2: begin // wait for the third bit
                if (!data) begin // third bit of the pattern
                    state <= 3; // wait for the fourth bit
                end else begin
                    state <= 0; // pattern not found, go back to IDLE
                end
            end
            3: begin // wait for the fourth bit
                if (data) begin // fourth bit of the pattern
                    state <= 4; // shift in the delay value
                end else begin
                    state <= 0; // pattern not found, go back to IDLE
                end
            end
            4: begin // shift in the delay value
                shift_reg <= {shift_reg[2:0], data}; // shift in the next bit
                if (shift_reg[3]) begin // most significant bit of the delay value
                    delay <= shift_reg; // store the delay value
                    state <= 5; // start counting
                    start_count <= 1;
                end else begin
                    state <= 4; // continue shifting
                end
            end
            5: begin // start counting
                if (start_count) begin
                    count_down <= (delay + 1) * 1000 - 1; // initialize the count_down register
                    remaining_time <= delay; // initialize the remaining_time register
                    start_count <= 0;
                    state <= 6; // start counting
                    counting <= 1;
                end
            end
            6: begin // counting
                if (count_down == 0) begin // counting finished
                    state <= 7; // assert done
                    counting <= 0;
                end else begin
                    count_down <= count_down - 1; // decrement the count_down register
                    if (count_down % 1000 == 0) begin // decrement the remaining_time register
                        remaining_time <= remaining_time - 1;
                    end
                end
            end
            7: begin // assert done
                done <= 1; // assert done
                if (ack) begin // ack received
                    state <= 0; // reset to IDLE
                    done <= 0;
                end
            end
            default: state <= 0; // default to IDLE
        endcase
    end
end

assign count = remaining_time; // assign the remaining_time to the count output

endmodule
module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] state; // 0 - IDLE, 1 - SHIFT, 2 - COUNT, 3 - DONE
reg [3:0] shift_reg; // store the next 4 bits
reg [9:0] counter; // count the clock cycles
reg [3:0] delay; // store the duration of the timer delay
reg [3:0] remaining; // store the remaining time

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        counting <= 0;
        done <= 0;
        counter <= 0;
        shift_reg <= 0;
        delay <= 0;
        remaining <= 0;
        count <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data == 1 && shift_reg == 0) begin
                    shift_reg <= 1;
                end else if (data == 1 && shift_reg == 8) begin
                    shift_reg <= 9;
                end else if (data == 0 && shift_reg == 1) begin
                    shift_reg <= 2;
                end else if (data == 0 && shift_reg == 9) begin
                    shift_reg <= 10; // found the pattern 1101
                    state <= 1; // go to SHIFT state
                end else if (data == 1 && shift_reg == 10) begin
                    shift_reg <= 11; // start shifting in the next 4 bits
                end else begin
                    shift_reg <= 0; // reset the shift register
                end
            end
            1: begin // SHIFT state
                shift_reg <= shift_reg << 1; // shift in the next bit
                if (data == 1) begin
                    shift_reg[0] <= 1;
                end
                if (shift_reg[3] == 1) begin // finished shifting in the next 4 bits
                    delay <= shift_reg[3:0];
                    remaining <= delay;
                    state <= 2; // go to COUNT state
                    counting <= 1; // assert counting output
                end
            end
            2: begin // COUNT state
                counter <= counter + 1;
                if (counter == (delay + 1) * 1000 - 1) begin // finished counting
                    state <= 3; // go to DONE state
                    counting <= 0; // deassert counting output
                    done <= 1; // assert done output
                end else if (counter % 1000 == 999) begin // update the remaining time
                    remaining <= remaining - 1;
                end
                count <= remaining;
            end
            3: begin // DONE state
                if (ack == 1) begin // received acknowledgement
                    state <= 0; // go back to IDLE state
                    done <= 0; // deassert done output
                    shift_reg <= 0; // reset the shift register
                    counter <= 0; // reset the counter
                    delay <= 0; // reset the delay
                    remaining <= 0; // reset the remaining time
                    count <= 0;
                end
            end
        endcase
    end
end

endmodule
module TopModule (
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
reg [3:0] remaining_time; // remaining time
reg [9:0] cycle_counter; // counter for clock cycles
reg [3:0] count_out; // output count

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        count_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data) begin // check for '1' in pattern
                    state <= 1; // move to next state to check '1' in pattern
                end else begin
                    state <= 0; // stay in IDLE state
                end
            end
            1: begin // checking for '1' in pattern
                if (data) begin // check for '1' in pattern
                    state <= 2; // move to next state to check '0' in pattern
                end else begin
                    state <= 0; // reset to IDLE state
                end
            end
            2: begin // checking for '0' in pattern
                if (~data) begin // check for '0' in pattern
                    state <= 3; // move to next state to check '1' in pattern
                end else begin
                    state <= 0; // reset to IDLE state
                end
            end
            3: begin // checking for '1' in pattern
                if (data) begin // check for '1' in pattern
                    state <= 4; // move to SHIFT state
                end else begin
                    state <= 0; // reset to IDLE state
                end
            end
            4: begin // SHIFT state
                delay <= {data, delay[2:0]}; // shift in delay value
                if (cycle_counter == 3) begin // check if all 4 bits have been shifted
                    state <= 5; // move to COUNT state
                    cycle_counter <= 0;
                end else begin
                    cycle_counter <= cycle_counter + 1;
                end
            end
            5: begin // COUNT state
                counting <= 1'b1;
                count_out <= delay; // output remaining time
                if (cycle_counter == ((delay + 1) * 1000 - 1)) begin // check if count is complete
                    state <= 6; // move to DONE state
                    cycle_counter <= 0;
                end else if (cycle_counter % 1000 == 999) begin // check if 1000 cycles have passed
                    delay <= delay - 1; // decrement remaining time
                end
                cycle_counter <= cycle_counter + 1;
            end
            6: begin // DONE state
                done <= 1'b1;
                counting <= 1'b0;
                if (ack) begin // check for acknowledgement
                    state <= 0; // reset to IDLE state
                    done <= 1'b0;
                end
            end
            default: state <= 0;
        endcase
    end
end

assign count = count_out;

endmodule
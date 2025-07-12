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
reg [3:0] delay; // store the delay value
reg [3:0] counter; // count the remaining time
reg [3:0] pattern; // store the received pattern
reg shift_done; // indicate if the delay value has been shifted in
reg counting_out; // output of the counting state
reg done_out; // output of the done state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        pattern <= 0;
        shift_done <= 0;
        counter <= 0;
        counting_out <= 0;
        done_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (pattern == 4'b1101) begin // check if the start pattern is received
                    state <= 1; // move to SHIFT state
                    pattern <= 0;
                end else if (data == 1'b1) begin // shift in the pattern
                    pattern <= {pattern[2:0], data};
                end else begin // shift in the pattern
                    pattern <= {pattern[2:0], data};
                end
            end
            1: begin // SHIFT state
                if (shift_done == 1'b1) begin // if the delay value has been shifted in
                    state <= 2; // move to COUNT state
                    counter <= {delay, 4'b1000}; // set the counter
                    counting_out <= 1'b1; // assert counting output
                end else begin
                    delay <= {delay[2:0], data}; // shift in the delay value
                    shift_done <= shift_done + 1'b1; // increment the shift done counter
                end
            end
            2: begin // COUNT state
                if (counter == 4'b0) begin // if the count is zero
                    state <= 3; // move to DONE state
                    counting_out <= 1'b0; // deassert counting output
                    done_out <= 1'b1; // assert done output
                end else begin
                    counter <= counter - 1'b1; // decrement the counter
                    count <= delay - (counter[3:0] / 4'b1000); // output the current remaining time
                end
            end
            3: begin // DONE state
                if (ack == 1'b1) begin // if the user acknowledges the timer
                    state <= 0; // reset to IDLE state
                    done_out <= 1'b0; // deassert done output
                end
            end
        endcase
    end
end

assign count = (state == 2)? delay - (counter[3:0] / 4'b1000) : 4'bxxxx;
assign counting = counting_out;
assign done = done_out;

endmodule
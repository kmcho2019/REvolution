module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] shift_count; // counter for shift state
reg [3:0] pattern; // register to store the last 4 bits of the input data

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        shift_count <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                pattern <= {pattern[2:0], data}; // shift in the new data bit
                if (pattern == 4'b1101) begin // check for the pattern 1101
                    state <= 1; // transition to SHIFT state
                    shift_count <= 0;
                end
            end
            1: begin // SHIFT state
                shift_ena <= 1'b1;
                if (shift_count == 4'd3) begin // check if 4 bits have been shifted in
                    state <= 2; // transition to COUNT state
                    shift_ena <= 1'b0;
                end else begin
                    shift_count <= shift_count + 1;
                end
            end
            2: begin // COUNT state
                counting <= 1'b1;
                if (done_counting) begin // check if the counters have finished counting
                    state <= 3; // transition to DONE state
                    counting <= 1'b0;
                end
            end
            3: begin // DONE state
                done <= 1'b1;
                if (ack) begin // check if the user has acknowledged the timer
                    state <= 0; // transition back to IDLE state
                    done <= 1'b0;
                end
            end
        endcase
    end
end

assign shift_ena = (state == 1) ? 1'b1 : 1'b0;
assign counting = (state == 2) ? 1'b1 : 1'b0;
assign done = (state == 3) ? 1'b1 : 1'b0;

endmodule
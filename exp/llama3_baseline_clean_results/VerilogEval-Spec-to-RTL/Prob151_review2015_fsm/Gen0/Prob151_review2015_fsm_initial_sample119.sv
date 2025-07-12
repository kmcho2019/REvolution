module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state; // 0: Idle, 1: Shift, 2: Count, 3: Done
reg [3:0] shift_counter; // counter for shift phase
reg [3:0] pattern; // stored input sequence

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // reset to Idle state
        shift_counter <= 0;
        pattern <= 0;
    end
    else begin
        case (state)
            0: begin // Idle
                if (pattern == 4'b1101) begin // pattern matched
                    state <= 1; // move to Shift state
                    shift_counter <= 1; // start shift counter
                end
                else if (data) begin // store input bit
                    pattern <= {pattern[2:0], 1'b1};
                end
                else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
            end
            1: begin // Shift
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4) begin // shift counter reached 4
                    state <= 2; // move to Count state
                end
            end
            2: begin // Count
                if (done_counting) begin
                    state <= 3; // move to Done state
                end
            end
            3: begin // Done
                if (ack) begin
                    state <= 0; // move back to Idle state
                end
            end
        endcase
    end
end

always @(*) begin
    shift_ena = (state == 1); // assert shift_ena in Shift state
    counting = (state == 2); // assert counting in Count state
    done = (state == 3); // assert done in Done state
end

endmodule
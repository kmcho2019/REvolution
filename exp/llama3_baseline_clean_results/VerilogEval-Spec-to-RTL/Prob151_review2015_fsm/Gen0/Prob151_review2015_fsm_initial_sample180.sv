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

// State definition
reg [2:0] state; // 3 states: IDLE (3'b000), SHIFT (3'b001), COUNT (3'b010), DONE (3'b011)
reg [3:0] pattern_detector; // to detect the pattern 1101
reg [2:0] shift_counter; // to count the 4 bits for the duration

// Initialize state and outputs
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        pattern_detector <= 4'b0000;
        shift_counter <= 3'b000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE
                pattern_detector <= {data, pattern_detector[3:1]};
                if (pattern_detector == 4'b1101) begin
                    state <= 3'b001;
                    shift_counter <= 3'b000;
                end else begin
                    state <= 3'b000;
                end
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            3'b001: begin // SHIFT
                shift_ena <= 1'b1;
                shift_counter <= shift_counter + 1'b1;
                if (shift_counter == 3'b100) begin
                    state <= 3'b010;
                end
            end
            3'b010: begin // COUNT
                counting <= 1'b1;
                shift_ena <= 1'b0;
                if (done_counting) begin
                    state <= 3'b011;
                end
            end
            3'b011: begin // DONE
                done <= 1'b1;
                counting <= 1'b0;
                if (ack) begin
                    state <= 3'b000;
                end
            end
        endcase
    end
end

endmodule
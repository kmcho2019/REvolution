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
reg [3:0] shift_counter; // counter for SHIFT state
reg [3:0] pattern_detector; // detects the pattern 1101

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        shift_counter <= 0;
        pattern_detector <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (pattern_detector == 4'b1101) begin
                    state <= 1; // SHIFT
                    pattern_detector <= 0;
                    shift_counter <= 1;
                end else begin
                    pattern_detector <= {pattern_detector[2:0], data};
                end
            end
            1: begin // SHIFT
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4) begin
                    state <= 2; // COUNT
                    shift_counter <= 0;
                end
            end
            2: begin // COUNT
                if (done_counting) begin
                    state <= 3; // DONE
                end
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0; // IDLE
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // IDLE
            shift_ena = 0;
            counting = 0;
            done = 0;
        end
        1: begin // SHIFT
            shift_ena = 1;
            counting = 0;
            done = 0;
        end
        2: begin // COUNT
            shift_ena = 0;
            counting = 1;
            done = 0;
        end
        3: begin // DONE
            shift_ena = 0;
            counting = 0;
            done = 1;
        end
    endcase
end

endmodule
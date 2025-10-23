module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    reg [3:0] state; // 4 states: Idle, Pattern_Detected, Shifting, Counting, Done
    reg [3:0] shift_counter; // Counter for shifting bits
    reg [3:0] pattern_detector; // Detector for the pattern 1101

    localparam IDLE = 4'b0000;
    localparam PATTERN_DETECTED = 4'b0001;
    localparam SHIFTING = 4'b0010;
    localparam COUNTING = 4'b0011;
    localparam DONE = 4'b0100;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state <= IDLE;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
            shift_counter <= 4'b0000;
            pattern_detector <= 4'b0000;
        end else begin
            case(state)
                IDLE: begin
                    if(pattern_detector == 4'b1101) begin
                        state <= PATTERN_DETECTED;
                        pattern_detector <= 4'b0000;
                    end else begin
                        pattern_detector <= {pattern_detector[2:0], data};
                    end
                end
                PATTERN_DETECTED: begin
                    state <= SHIFTING;
                    shift_ena <= 1'b1;
                end
                SHIFTING: begin
                    if(shift_counter == 4'b1000) begin
                        shift_ena <= 1'b0;
                        state <= COUNTING;
                    end else begin
                        shift_counter <= shift_counter + 1'b1;
                    end
                end
                COUNTING: begin
                    if(done_counting) begin
                        counting <= 1'b0;
                        done <= 1'b1;
                        state <= DONE;
                    end
                end
                DONE: begin
                    if(ack) begin
                        done <= 1'b0;
                        state <= IDLE;
                    end
                end
            endcase
            if(state != SHIFTING) begin
                shift_counter <= 4'b0000;
            end
            if(state != COUNTING) begin
                counting <= 1'b0;
            end
            if(state == COUNTING) begin
                counting <= 1'b1;
            end
        end
    end

endmodule
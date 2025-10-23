module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [2:0] top_state; // Top-level state machine
reg [2:0] pattern_state; // Pattern detection state machine
reg [1:0] shift_state; // Shift state machine
reg [1:0] count_state; // Counting state machine
reg [3:0] pattern; // Register to store the input pattern
reg [2:0] shift_count; // Counter for shifting

localparam IDLE = 3'b001;
localparam PATTERN_DETECT = 3'b010;
localparam SHIFTING = 3'b100;
localparam COUNTING_STATE = 3'b000;

localparam PATTERN_IDLE = 3'b001;
localparam PATTERN_DETECTED = 3'b010;

localparam SHIFT_IDLE = 2'b00;
localparam SHIFTING_STATE = 2'b01;
localparam SHIFT_DONE = 2'b10;

localparam COUNT_IDLE = 2'b00;
localparam COUNTING = 2'b01;
localparam COUNT_DONE = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        top_state <= IDLE;
        pattern_state <= PATTERN_IDLE;
        shift_state <= SHIFT_IDLE;
        count_state <= COUNT_IDLE;
        pattern <= 4'b0000;
        shift_count <= 3'b000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (top_state)
            IDLE: begin
                case (pattern_state)
                    PATTERN_IDLE: begin
                        pattern[3:1] <= pattern[2:0];
                        pattern[0] <= data;
                        if (pattern == 4'b1101) begin
                            pattern_state <= PATTERN_DETECTED;
                            top_state <= PATTERN_DETECT;
                        end else begin
                            pattern_state <= PATTERN_IDLE;
                        end
                    end
                    PATTERN_DETECTED: begin
                        pattern_state <= PATTERN_IDLE;
                    end
                endcase
            end
            PATTERN_DETECT: begin
                top_state <= SHIFTING;
            end
            SHIFTING: begin
                case (shift_state)
                    SHIFT_IDLE: begin
                        shift_state <= SHIFTING_STATE;
                    end
                    SHIFTING_STATE: begin
                        if (shift_count == 3'b100) begin
                            shift_state <= SHIFT_DONE;
                            top_state <= COUNTING_STATE;
                        end else begin
                            shift_count <= shift_count + 1'b1;
                        end
                    end
                    SHIFT_DONE: begin
                        shift_state <= SHIFT_IDLE;
                    end
                endcase
            end
            COUNTING_STATE: begin
                case (count_state)
                    COUNT_IDLE: begin
                        if (done_counting) begin
                            count_state <= COUNTING;
                            counting <= 1'b1;
                            done <= 1'b1;
                        end
                    end
                    COUNTING: begin
                        if (ack) begin
                            count_state <= COUNT_DONE;
                            top_state <= IDLE;
                            counting <= 1'b0;
                            done <= 1'b0;
                        end
                    end
                    COUNT_DONE: begin
                        count_state <= COUNT_IDLE;
                    end
                endcase
            end
        endcase
    end
end

always @(*) begin
    case (top_state)
        IDLE: begin
            shift_ena = 1'b0;
        end
        PATTERN_DETECT: begin
            shift_ena = 1'b0;
        end
        SHIFTING: begin
            case (shift_state)
                SHIFT_IDLE: begin
                    shift_ena = 1'b0;
                end
                SHIFTING_STATE: begin
                    shift_ena = 1'b1;
                end
                SHIFT_DONE: begin
                    shift_ena = 1'b0;
                end
            endcase
        end
        COUNTING_STATE: begin
            shift_ena = 1'b0;
        end
    endcase
end

endmodule
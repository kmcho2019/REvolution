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

// Define the states
localparam IDLE = 2'b00;
localparam PATTERN_DETECT = 2'b01;
localparam SHIFT = 2'b10;
localparam COUNTING_DONE = 2'b11;

reg [1:0] state;
reg [3:0] pattern_detector;
reg [3:0] shift_register;
reg [1:0] shift_count;
reg counting_done;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_detector <= 4'b0000;
        shift_register <= 4'b0000;
        shift_count <= 2'b00;
        counting_done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                // Pattern detector
                pattern_detector[3:1] <= pattern_detector[2:0];
                pattern_detector[0] <= data;
                if (pattern_detector == 4'b1101) begin
                    state <= PATTERN_DETECT;
                end
            end
            PATTERN_DETECT: begin
                state <= SHIFT;
                shift_count <= 2'b00; // Reset shift count
            end
            SHIFT: begin
                // Shift register
                shift_register[3:1] <= shift_register[2:0];
                shift_register[0] <= data;
                shift_count <= shift_count + 1'b1;
                if (shift_count == 2'b11) begin // Shifted 4 times
                    state <= COUNTING_DONE;
                end
            end
            COUNTING_DONE: begin
                // Counter controller
                if (done_counting &&!counting_done) begin
                    counting_done <= 1'b1;
                end
                // Done signal generator
                if (ack && counting_done) begin
                    state <= IDLE; // Reset state on ack
                    counting_done <= 1'b0;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        PATTERN_DETECT: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        SHIFT: begin
            shift_ena = 1'b1;
            counting = 1'b0;
            done = 1'b0;
        end
        COUNTING_DONE: begin
            shift_ena = 1'b0;
            counting = 1'b1;
            done = counting_done;
        end
        default: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
    endcase
end

endmodule
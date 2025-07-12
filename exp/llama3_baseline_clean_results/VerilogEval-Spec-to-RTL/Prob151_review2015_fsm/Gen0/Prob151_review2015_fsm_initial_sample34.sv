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

// Define states
localparam IDLE = 4'b0000;
localparam PATTERN_MATCHED = 4'b0001;
localparam SHIFTING = 4'b0010;
localparam COUNTING = 4'b0011;
localparam DONE = 4'b0100;

reg [3:0] state;
reg [3:0] next_state;
reg [3:0] pattern_detected;
reg [2:0] shift_counter;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_detected <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_counter <= 0;
    end else begin
        state <= next_state;
        pattern_detected <= {data, pattern_detected[3:1]};
        if (next_state == SHIFTING) begin
            shift_counter <= shift_counter + 1;
        end else begin
            shift_counter <= 0;
        end
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (pattern_detected == 4'b1101) begin
                next_state = PATTERN_MATCHED;
            end else begin
                next_state = IDLE;
            end
            shift_ena = 0;
            counting = 0;
            done = 0;
        end
        PATTERN_MATCHED: begin
            next_state = SHIFTING;
            shift_ena = 1;
            counting = 0;
            done = 0;
        end
        SHIFTING: begin
            if (shift_counter == 4) begin
                next_state = COUNTING;
            end else begin
                next_state = SHIFTING;
            end
            shift_ena = (shift_counter < 4) ? 1 : 0;
            counting = 0;
            done = 0;
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
            shift_ena = 0;
            counting = 1;
            done = 0;
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
            shift_ena = 0;
            counting = 0;
            done = 1;
        end
        default: begin
            next_state = IDLE;
            shift_ena = 0;
            counting = 0;
            done = 0;
        end
    endcase
end

endmodule
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // FSM state encoding (2-bit Gray for simplicity + separate DONE)
    localparam [1:0]
        IDLE  = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b11,
        DONE  = 2'b10;

    reg [1:0] state, next_state;

    // Shift register to detect pattern 1101 on 'data'
    reg [3:0] pattern_shift;

    // 2-bit counter for shift cycles (0 to 3)
    reg [1:0] shift_count;

    // Pattern detected if pattern_shift == 4'b1101
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Shift in data to pattern_shift at every clock (except during reset)
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'b0000;
        end else begin
            pattern_shift <= {pattern_shift[2:0], data};
        end
    end

    // FSM sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;

            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // If pattern detected, go to SHIFT state
                if (pattern_detected)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end

            SHIFT: begin
                // After 4 shift cycles, go to COUNT
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end

            COUNT: begin
                // Wait until done_counting asserted
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            DONE: begin
                // Wait for ack to return to IDLE
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Moore outputs for glitch-free signals
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule
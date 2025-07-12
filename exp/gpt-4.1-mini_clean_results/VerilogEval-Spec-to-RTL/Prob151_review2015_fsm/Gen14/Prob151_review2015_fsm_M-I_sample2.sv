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

    // Pattern detection: 4-bit shift register to detect '1101' pattern
    reg [3:0] pattern_shiftreg;

    wire pattern_detected = (pattern_shiftreg == 4'b1101);

    // FSM states one-hot encoding
    localparam IDLE  = 4'b0001,
               SHIFT = 4'b0010,
               COUNT = 4'b0100,
               DONE  = 4'b1000;

    reg [3:0] state, next_state;

    // 2-bit Gray code counter for shift cycles (4 cycles)
    reg [1:0] shift_count; 
    wire [1:0] shift_count_gray_next;
    // Gray count sequence: 00->01->11->10->00
    // Encoding: 0->1->3->2->0 (binary: 00->01->11->10->00)
    // We'll increment gray code counter in SHIFT

    // Compute next Gray code count
    function [1:0] gray_inc;
        input [1:0] g;
        begin
            case (g)
                2'b00: gray_inc = 2'b01;
                2'b01: gray_inc = 2'b11;
                2'b11: gray_inc = 2'b10;
                2'b10: gray_inc = 2'b00;
                default: gray_inc = 2'b00;
            endcase
        end
    endfunction

    // Detect shift count reached 4 cycles after 4 Gray states:
    // We'll define shift_count == 2'b00 means start, after 4 increments back to 00.
    // So we start at 00, increment each clock in SHIFT,
    // when next state gray_inc(shift_count)==00, means completed 4 cycles.
    wire shift_done = (gray_inc(shift_count) == 2'b00);

    // pattern_shiftreg shift at each clk
    always @(posedge clk) begin
        if (reset) begin
            pattern_shiftreg <= 4'b0000;
        end else begin
            pattern_shiftreg <= {pattern_shiftreg[2:0], data};
        end
    end

    // FSM state register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;

            if (state == SHIFT)
                shift_count <= gray_inc(shift_count);
            else
                shift_count <= 2'b00;
        end
    end

    // FSM next state logic (one-hot encoding)
    always @(*) begin
        // Default next state hold
        next_state = state;

        case (state)
            IDLE: begin
                if (pattern_detected)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end

            SHIFT: begin
                if (shift_done)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end

            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Outputs: Moore style based on state
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule
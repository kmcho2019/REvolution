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

    // FSM states encoding (2 bits for minimal states)
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state, next_state;

    // 4-bit shift register to detect "1101"
    reg [3:0] pattern_shift_reg;

    // Shift counter for SHIFT state (needs to count 4 cycles: 0..3)
    reg [2:0] shift_counter;

    // Pattern detection: 1101 binary is 4'b1101 = 4'hD
    wire pattern_detected = (pattern_shift_reg == 4'b1101);

    // Shift in serial data every clock
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift_reg <= 4'b0000;
        end else begin
            pattern_shift_reg <= {pattern_shift_reg[2:0], data};
        end
    end

    // FSM state register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_counter <= 3'd0;
        end else begin
            state <= next_state;

            if (state == SHIFT)
                shift_counter <= shift_counter + 3'd1;
            else
                shift_counter <= 3'd0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case (state)
            IDLE: begin
                if (pattern_detected)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                if (shift_counter == 3'd3)
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

    // Output logic (Moore outputs)
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule
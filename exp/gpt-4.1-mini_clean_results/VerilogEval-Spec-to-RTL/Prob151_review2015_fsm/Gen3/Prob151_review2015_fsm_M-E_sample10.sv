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

    // State encoding
    localparam IDLE  = 2'd0,
               SHIFT = 2'd1,
               COUNT = 2'd2,
               DONE  = 2'd3;

    reg [1:0] state, next_state;

    // 4-bit shift register for pattern detection
    reg [3:0] shift_reg;

    // 2-bit counter for shift cycles (0 to 3)
    reg [1:0] shift_count;

    // Pattern constant 4'b1101
    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic: shift register, state, and counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_count <= 2'd0;
        end else begin
            // Shift in new data bit every cycle
            shift_reg <= {shift_reg[2:0], data};
            
            // Update state
            state <= next_state;

            // Update shift counter only in SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Detect pattern on shift register
                if (shift_reg == PATTERN)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                // After 4 cycles of asserting shift_ena, move to COUNT
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                // Wait for done_counting to assert done
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                // Wait for user to acknowledge, then reset
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
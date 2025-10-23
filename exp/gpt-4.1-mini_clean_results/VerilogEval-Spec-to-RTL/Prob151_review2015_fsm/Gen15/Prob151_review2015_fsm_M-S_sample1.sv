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
    localparam [1:0]
        IDLE  = 2'd0, // searching for pattern
        SHIFT = 2'd1, // shifting 4 bits
        WAIT  = 2'd2; // waiting for done_counting & ack

    reg [1:0] state, next_state;
    reg [1:0] shift_count;
    reg [3:0] pattern_shift_reg;

    // Shift in serial data for pattern detection
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift_reg <= 4'b0000;
        end else begin
            pattern_shift_reg <= {pattern_shift_reg[2:0], data};
        end
    end

    // State and shift_count registers
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

    // Next-state logic
    always @(*) begin
        case (state)
            IDLE: 
                // Pattern '1101' detection
                if (pattern_shift_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = IDLE;

            SHIFT:
                if (shift_count == 2'd3)
                    next_state = WAIT;
                else
                    next_state = SHIFT;

            WAIT:
                if (done_counting)
                    if (ack)
                        next_state = IDLE;
                    else
                        next_state = WAIT;
                else
                    next_state = WAIT;

            default:
                next_state = IDLE;
        endcase
    end

    // Moore outputs
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == WAIT) && !done_counting;
        done      = (state == WAIT) && done_counting;
    end

endmodule
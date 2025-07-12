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

    // One-hot states: only one bit high at a time
    localparam S0       = 7'b0000001; // waiting for pattern
    localparam S_SHIFT0 = 7'b0000010; // shift_ena cycle 1
    localparam S_SHIFT1 = 7'b0000100; // shift_ena cycle 2
    localparam S_SHIFT2 = 7'b0001000; // shift_ena cycle 3
    localparam S_SHIFT3 = 7'b0010000; // shift_ena cycle 4
    localparam S_COUNT  = 7'b0100000; // counting delay
    localparam S_DONE   = 7'b1000000; // done, wait ack

    reg [6:0] state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_reg, next_pattern_reg;

    // Combinational logic for pattern detection: check for 1101 (binary 4'b1101 = 13 decimal)
    wire pattern_match = (pattern_reg == 4'b1101);

    // Next state logic
    always @(*) begin
        next_state = state;
        next_pattern_reg = {pattern_reg[2:0], data}; // shift in new bit
        // Default output signals (registered separately)
        case (state)
            S0: begin
                if (pattern_match)
                    next_state = S_SHIFT0;
                else
                    next_state = S0;
            end
            S_SHIFT0: next_state = S_SHIFT1;
            S_SHIFT1: next_state = S_SHIFT2;
            S_SHIFT2: next_state = S_SHIFT3;
            S_SHIFT3: next_state = S_COUNT;
            S_COUNT:  next_state = done_counting ? S_DONE : S_COUNT;
            S_DONE:   next_state = ack ? S0 : S_DONE;
            default:  next_state = S0;
        endcase
    end

    // Sequential logic: state and pattern_reg update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            pattern_reg <= 4'b0000;
        end else begin
            state <= next_state;
            // Update pattern register only when searching for pattern (S0)
            // Otherwise hold or shift pattern_reg to track input data continuously for correct detection
            if (state == S0)
                pattern_reg <= next_pattern_reg;
            else
                pattern_reg <= pattern_reg; // hold pattern_reg during other states
        end
    end

    // Outputs registered to reduce glitches and glitches caused by combinational logic
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;
        end else begin
            shift_ena <= (state == S_SHIFT0) | (state == S_SHIFT1) | (state == S_SHIFT2) | (state == S_SHIFT3);
            counting  <= (state == S_COUNT);
            done      <= (state == S_DONE);
        end
    end

endmodule
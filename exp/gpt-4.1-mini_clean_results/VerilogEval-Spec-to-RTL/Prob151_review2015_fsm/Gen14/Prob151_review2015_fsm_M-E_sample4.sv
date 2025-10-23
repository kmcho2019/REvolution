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

    // One-hot state encoding
    localparam SEARCH  = 5'b00001;
    localparam SHIFT   = 5'b00010;
    localparam COUNT   = 5'b00100;
    localparam DONE    = 5'b01000;
    localparam IDLE    = 5'b10000; // Not really needed, but reserve if desired

    reg [4:0] state, next_state;

    // 4-bit shift register to detect pattern 1101
    reg [3:0] pattern_reg;

    // 3-bit counter for shift cycles (counts from 0 to 3)
    reg [2:0] shift_count;

    // Sequential logic: state, pattern register, and shift_count update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_reg <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            // Update pattern_reg by shifting in data bit
            if (state == SEARCH) begin
                pattern_reg <= {pattern_reg[2:0], data};
                shift_count <= 3'd0;
            end else if (state == SHIFT) begin
                shift_count <= shift_count + 3'd1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;

        case (state)
            SEARCH: begin
                // Detect pattern '1101' in pattern_reg
                // After shifting in current data bit, pattern_reg contains last 4 bits
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;
            end

            SHIFT: begin
                // After 4 cycles of shift_ena, go to COUNT
                if (shift_count == 3'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end

            COUNT: begin
                // Wait for done_counting signal
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            DONE: begin
                // Wait for ack to return to SEARCH
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Outputs combinational from state (Moore FSM)
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule
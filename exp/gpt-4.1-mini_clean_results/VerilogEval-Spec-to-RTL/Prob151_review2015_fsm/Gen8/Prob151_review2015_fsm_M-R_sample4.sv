module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // State encoding (one-hot)
    typedef enum logic [5:0] {
        IDLE    = 6'b000001,  // Waiting for pattern detection
        SHIFT0  = 6'b000010,  // Shift cycle 1
        SHIFT1  = 6'b000100,  // Shift cycle 2
        SHIFT2  = 6'b001000,  // Shift cycle 3
        SHIFT3  = 6'b010000,  // Shift cycle 4
        COUNT   = 6'b100000,  // Waiting for counting done
        DONE_S  = 6'b1000000  // Done, wait for ack (NOTE: size increased to 7 bits for DONE_S)
    } state_t;

    // Since we need 7 bits to encode DONE_S uniquely:
    localparam IDLE_L   = 7'b0000001;
    localparam SHIFT0_L = 7'b0000010;
    localparam SHIFT1_L = 7'b0000100;
    localparam SHIFT2_L = 7'b0001000;
    localparam SHIFT3_L = 7'b0010000;
    localparam COUNT_L  = 7'b0100000;
    localparam DONE_L   = 7'b1000000;

    reg [6:0] state, next_state;

    // Pattern detection shift register, only shifted in IDLE state
    reg [3:0] pattern_shift;

    wire pattern_detected = (pattern_shift == 4'b1101);

    // Sequential logic: state and pattern_shift update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE_L;
            pattern_shift <= 4'b0000;
        end else begin
            state <= next_state;

            if (state == IDLE_L)
                pattern_shift <= {pattern_shift[2:0], data};
            else
                pattern_shift <= pattern_shift; // Hold pattern_shift in other states
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE_L: begin
                if (pattern_detected)
                    next_state = SHIFT0_L;
                else
                    next_state = IDLE_L;
            end

            SHIFT0_L: next_state = SHIFT1_L;
            SHIFT1_L: next_state = SHIFT2_L;
            SHIFT2_L: next_state = SHIFT3_L;
            SHIFT3_L: next_state = COUNT_L;

            COUNT_L: begin
                if (done_counting)
                    next_state = DONE_L;
                else
                    next_state = COUNT_L;
            end

            DONE_L: begin
                if (ack)
                    next_state = IDLE_L;
                else
                    next_state = DONE_L;
            end

            default: next_state = IDLE_L;
        endcase
    end

    // Output logic (Moore outputs)
    assign shift_ena = (state == SHIFT0_L) ||
                       (state == SHIFT1_L) ||
                       (state == SHIFT2_L) ||
                       (state == SHIFT3_L);

    assign counting  = (state == COUNT_L);
    assign done      = (state == DONE_L);

endmodule
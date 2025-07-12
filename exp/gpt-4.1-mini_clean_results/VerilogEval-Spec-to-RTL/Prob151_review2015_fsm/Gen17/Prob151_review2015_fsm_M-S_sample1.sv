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

    // FSM states
    localparam IDLE  = 2'd0,  // Searching for pattern
               SHIFT = 2'd1,  // Shifting 4 bits
               COUNT = 2'd2,  // Waiting for counting to finish
               DONE  = 2'd3;  // Timer done, waiting for ack

    reg [1:0] state, next_state;
    reg [1:0] shift_count;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Pattern to detect: 4'b1101
    wire pattern_found = (pattern_shift == 4'b1101);

    // Sequential logic for pattern shift register and FSM
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'd0;
            state <= IDLE;
            shift_count <= 2'd0;
        end else begin
            // Shift in data bits only in IDLE state
            if (state == IDLE) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end else begin
                // Hold shift register value in other states
                pattern_shift <= pattern_shift;
            end

            state <= next_state;

            // Shift counter increments only in SHIFT state
            if (state == SHIFT)
                shift_count <= shift_count + 1'b1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = pattern_found ? SHIFT : IDLE;
            SHIFT: next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE:  next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Outputs combinational from current state
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule
module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

    // State encoding
    localparam [1:0]
        IDLE  = 2'd0, // searching for pattern
        SHIFT = 2'd1, // shifting 4 bits
        COUNT = 2'd2, // waiting for counting to finish
        DONE  = 2'd3; // done, waiting for ack

    reg [1:0] state, next_state;
    reg [1:0] shift_count;
    reg [3:0] pattern_shift; // shift register to detect 1101

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'd0;
            pattern_shift <= 4'd0;
        end else begin
            state <= next_state;

            // Update pattern_shift only in IDLE state
            if (state == IDLE) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end

            // Manage shift_count in SHIFT state
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                if (pattern_shift == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = IDLE;

            SHIFT: 
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;

            COUNT: 
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;

            DONE:
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;

            default: next_state = IDLE;
        endcase
    end

    // Outputs
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule
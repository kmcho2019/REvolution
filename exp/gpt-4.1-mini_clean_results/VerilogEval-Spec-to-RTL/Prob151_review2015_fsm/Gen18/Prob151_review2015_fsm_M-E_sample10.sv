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

    // One-hot state encoding
    localparam SEARCH   = 5'b00001;
    localparam SHIFT    = 5'b00010;
    localparam COUNT    = 5'b00100;
    localparam DONE     = 5'b01000;
    localparam WAIT_ACK = 5'b10000; // combined done + wait for ack

    reg [4:0] state, next_state;

    reg [3:0] pattern_sr;    // 4-bit shift register for pattern detection
    reg [2:0] shift_counter; // count 4 shift cycles (0 to 3)

    // Update pattern shift register and state sequentially
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_sr <= 4'b0000;
            shift_counter <= 3'd0;
        end else begin
            state <= next_state;

            // Shift pattern SR only in SEARCH state to track incoming pattern
            if (state == SEARCH) begin
                pattern_sr <= {pattern_sr[2:0], data};
            end

            // Count shift cycles only in SHIFT state
            if (state == SHIFT) begin
                shift_counter <= shift_counter + 3'd1;
            end else begin
                shift_counter <= 3'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case (state)
            SEARCH: begin
                // Check if pattern_sr matches '1101'
                if (pattern_sr == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;
            end

            SHIFT: begin
                // After 4 cycles of shifting (0..3), proceed to COUNT
                if (shift_counter == 3'd3)
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
                // Assert done output and wait one cycle to move to WAIT_ACK
                // This state indicates done asserted, next cycle go to WAIT_ACK
                next_state = WAIT_ACK;
            end

            WAIT_ACK: begin
                // Wait for ack, then return to SEARCH
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT_ACK;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Output logic from states
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE) || (state == WAIT_ACK);

endmodule
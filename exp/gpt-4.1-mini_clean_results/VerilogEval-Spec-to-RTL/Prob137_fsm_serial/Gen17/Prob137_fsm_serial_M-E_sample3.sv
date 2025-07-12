module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding for simplicity and speed
    localparam IDLE   = 4'b0001;
    localparam START  = 4'b0010;
    localparam DATA   = 4'b0100;
    localparam STOP   = 4'b1000;
    localparam ERROR  = 4'b10000; // Using 5 bits to hold ERROR state for clarity

    reg [4:0] state, next_state;

    // Counter for bit index (0 to 7 for data bits)
    reg [2:0] bit_idx;

    // Shift register for data accumulation
    reg [7:0] shift_reg;

    // Because the protocol sends bits on every clock (no oversampling assumed),
    // just sample on each clock cycle after start bit detection.
    // If oversampling is needed, a clock divider / sampling counter would be added.

    // Sequential block: state update, registers, and done output
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_idx   <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // Default done pulse to 0 unless frame received correctly

            case (state)
                IDLE: begin
                    bit_idx   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                START: begin
                    // Verify start bit is 0, no registers to update here (just checking input)
                    // bit_idx reset done in IDLE already
                end

                DATA: begin
                    // Capture bits LSB first directly into bit_idx position
                    // Assign bit_idx-th bit of shift_reg = in
                    shift_reg[bit_idx] <= in;
                    bit_idx <= bit_idx + 1'b1;
                end

                STOP: begin
                    // No data bits updated here; check stop bit on 'in'
                    // If stop bit = 1 => done pulse, else error handling
                end

                ERROR: begin
                    // Wait for line to go idle (in==1) to resync
                    bit_idx   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    bit_idx   <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Combinational block: next state logic and done output generation
    always @(*) begin
        next_state = state; // Default hold current state

        case(state)
            IDLE: begin
                // Wait for start bit (logic 0)
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                // Confirm start bit still 0 (could double-check line stable if needed)
                // Immediately proceed to DATA state next cycle
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE; // Noise or error, wait for next start bit
            end

            DATA: begin
                // Collect 8 bits indexed by bit_idx 0..7
                if (bit_idx == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                // Check stop bit is 1
                if (in == 1'b1) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end

            ERROR: begin
                // Wait for line to return idle (logic 1)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

    // done pulse generation: set done in STOP state when stop bit == 1
    always @(posedge clk) begin
        if (!reset && state == STOP && in == 1'b1)
            done <= 1'b1;
    end

endmodule
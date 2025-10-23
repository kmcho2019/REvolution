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
    localparam
        S_SEARCH0  = 6'b000001, // no bits matched
        S_SEARCH1  = 6'b000010, // matched '1'
        S_SEARCH2  = 6'b000100, // matched '11'
        S_SEARCH3  = 6'b001000, // matched '110'
        S_SHIFT    = 6'b010000, // shifting 4 bits, controlled by shift_count
        S_COUNT    = 6'b100000, // waiting for done_counting
        S_DONE     = 6'b000000; // done and waiting for ack, will be represented by special reg (see below)

    // Since we need 7 states total and we have 6 one-hot bits, use S_DONE as a separate reg flag
    // or we can encode S_DONE as zero state and use a separate reg flag.

    // However, to keep one-hot clean, add one more bit:
    localparam S_DONE_BIT = 6; // use bit 6 as done state

    reg [6:1] state, next_state; // one-hot with bits 1..6

    // Define state bits for clarity
    localparam
        BIT_SEARCH0 = 1,
        BIT_SEARCH1 = 2,
        BIT_SEARCH2 = 3,
        BIT_SEARCH3 = 4,
        BIT_SHIFT   = 5,
        BIT_COUNT   = 6,
        BIT_DONE    = 7; // we need 7 bits for done

    reg [7:1] state_w, next_state_w;
    // We'll use 7 bits to encode all states one-hot

    // Shift counter for shift cycles (2 bits needed for 0..3)
    reg [1:0] shift_count, shift_count_next;

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            state_w <= 7'b0000001; // S_SEARCH0
            shift_count <= 2'd0;
        end else begin
            state_w <= next_state_w;
            shift_count <= shift_count_next;
        end
    end

    // Next state and shift_count logic
    always @(*) begin
        // Defaults
        next_state_w = 7'b0;
        shift_count_next = shift_count;

        case (1'b1) // one-hot decode
            state_w[BIT_SEARCH0]: begin
                // In SEARCH0, look for first '1' of pattern 1101
                if (data)
                    next_state_w[BIT_SEARCH1] = 1'b1;
                else
                    next_state_w[BIT_SEARCH0] = 1'b1;
                shift_count_next = 2'd0;
            end

            state_w[BIT_SEARCH1]: begin
                // matched first '1', expect second '1'
                if (data)
                    next_state_w[BIT_SEARCH2] = 1'b1;
                else
                    next_state_w[BIT_SEARCH0] = 1'b1;
                shift_count_next = 2'd0;
            end

            state_w[BIT_SEARCH2]: begin
                // matched '11', expect '0'
                if (~data)
                    next_state_w[BIT_SEARCH3] = 1'b1;
                else
                    next_state_w[BIT_SEARCH2] = 1'b1; // Remain here on unexpected '1'
                shift_count_next = 2'd0;
            end

            state_w[BIT_SEARCH3]: begin
                // matched '110', expect '1'
                if (data) begin
                    next_state_w[BIT_SHIFT] = 1'b1;
                    shift_count_next = 2'd0;
                end else begin
                    next_state_w[BIT_SEARCH0] = 1'b1;
                    shift_count_next = 2'd0;
                end
            end

            state_w[BIT_SHIFT]: begin
                // shift_ena asserted 4 cycles, controlled by shift_count
                if (shift_count == 2'd3) begin
                    next_state_w[BIT_COUNT] = 1'b1;
                    shift_count_next = 2'd0;
                end else begin
                    next_state_w[BIT_SHIFT] = 1'b1;
                    shift_count_next = shift_count + 1'b1;
                end
            end

            state_w[BIT_COUNT]: begin
                // wait for done_counting
                if (done_counting)
                    next_state_w[BIT_DONE] = 1'b1;
                else
                    next_state_w[BIT_COUNT] = 1'b1;
                shift_count_next = 2'd0;
            end

            state_w[BIT_DONE]: begin
                // wait for ack
                if (ack)
                    next_state_w[BIT_SEARCH0] = 1'b1;
                else
                    next_state_w[BIT_DONE] = 1'b1;
                shift_count_next = 2'd0;
            end

            default: begin
                next_state_w[BIT_SEARCH0] = 1'b1;
                shift_count_next = 2'd0;
            end
        endcase
    end

    // Registered outputs for glitch-free timing
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            // shift_ena true only in SHIFT state
            shift_ena <= state_w[BIT_SHIFT];

            counting <= state_w[BIT_COUNT];

            done <= state_w[BIT_DONE];
        end
    end

endmodule
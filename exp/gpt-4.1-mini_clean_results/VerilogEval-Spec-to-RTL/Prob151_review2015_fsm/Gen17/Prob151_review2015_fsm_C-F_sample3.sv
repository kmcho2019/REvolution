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

    // FSM state encoding with localparam for readability and synthesis friendliness
    localparam [2:0]
        SEARCH0 = 3'd0, // no bits matched
        SEARCH1 = 3'd1, // matched '1'
        SEARCH2 = 3'd2, // matched '11'
        SEARCH3 = 3'd3, // matched '110'
        SHIFT   = 3'd4, // shifting in 4 bits
        COUNT   = 3'd5, // counting delay
        DONE    = 3'd6; // done, waiting for ack

    reg [2:0] state, next_state;
    reg [1:0] shift_count, next_shift_count;

    // Combinational next state logic and shift_count update
    always @(*) begin
        // Default next values
        next_state = state;
        next_shift_count = shift_count;

        case (state)
            SEARCH0: begin
                next_state = data ? SEARCH1 : SEARCH0;
                next_shift_count = 2'd0;
            end
            SEARCH1: begin
                next_state = data ? SEARCH2 : SEARCH0;
                next_shift_count = 2'd0;
            end
            SEARCH2: begin
                // Expect '0' for next bit; if '1', stay to allow overlapping patterns
                next_state = (~data) ? SEARCH3 : SEARCH2;
                next_shift_count = 2'd0;
            end
            SEARCH3: begin
                next_state = data ? SHIFT : SEARCH0;
                next_shift_count = 2'd0;
            end
            SHIFT: begin
                // Count exactly 4 shift cycles: shift_count runs 0..3
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
                next_shift_count = shift_count + 2'd1;
            end
            COUNT: begin
                next_state = done_counting ? DONE : COUNT;
                next_shift_count = 2'd0;
            end
            DONE: begin
                next_state = ack ? SEARCH0 : DONE;
                next_shift_count = 2'd0;
            end
            default: begin
                next_state = SEARCH0;
                next_shift_count = 2'd0;
            end
        endcase
    end

    // Sequential state and shift_count updates with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            shift_count <= next_shift_count;
        end
    end

    // Moore outputs derived purely from current state for glitch-free timing
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule
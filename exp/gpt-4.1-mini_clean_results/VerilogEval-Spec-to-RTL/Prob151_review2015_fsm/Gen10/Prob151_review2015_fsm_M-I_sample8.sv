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

    // One-hot state encoding (7 states)
    typedef enum logic [6:0] {
        SEARCH0 = 7'b000_0001, // no pattern bits matched
        SEARCH1 = 7'b000_0010, // matched '1'
        SEARCH2 = 7'b000_0100, // matched '11'
        SEARCH3 = 7'b000_1000, // matched '110'
        SHIFT   = 7'b001_0000, // shifting delay bits (4 cycles)
        COUNT   = 7'b010_0000, // counting delay
        DONE    = 7'b100_0000  // done, waiting for ack
    } state_t;

    state_t state, next_state;

    // 2-bit counter for shift cycles (0 to 3)
    reg [1:0] shift_count;

    // Clock enable for shift_count only in SHIFT state
    wire shift_ena_int = (state == SHIFT);

    // Sequential logic: state and shift_count update with synchronous reset
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if (shift_ena_int)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state combinational logic (Moore FSM)
    always_comb begin
        next_state = state;
        case (state)
            SEARCH0: next_state = data ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = data ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = (~data) ? SEARCH3 : SEARCH2; // Allow overlapping pattern on '1'
            SEARCH3: next_state = data ? SHIFT : SEARCH0;
            SHIFT:   next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT:   next_state = done_counting ? DONE : COUNT;
            DONE:    next_state = ack ? SEARCH0 : DONE;
            default: next_state = SEARCH0;
        endcase
    end

    // Outputs driven combinationally (Moore FSM)
    assign shift_ena = shift_ena_int;
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule
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

    // State encoding (3-bit binary enumeration)
    typedef enum logic [2:0] {
        SEARCH0 = 3'd0, // no pattern bits matched
        SEARCH1 = 3'd1, // matched '1'
        SEARCH2 = 3'd2, // matched '11'
        SEARCH3 = 3'd3, // matched '110'
        SHIFT   = 3'd4, // shifting delay bits (4 cycles)
        COUNT   = 3'd5, // counting delay
        DONE    = 3'd6  // done, waiting for ack
    } state_t;

    state_t state, next_state;

    // 2-bit counter for shift cycles (0 to 3)
    reg [1:0] shift_count;

    // Sequential logic: state and shift_count update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state combinational logic (Moore FSM)
    always @(*) begin
        unique case (state)
            SEARCH0: next_state = (data) ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = (data) ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = (~data) ? SEARCH3 : SEARCH2; // expect '0', else stay SEARCH2 for overlapping
            SEARCH3: next_state = (data) ? SHIFT : SEARCH0;    // expect final '1'
            SHIFT:   next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT:   next_state = done_counting ? DONE : COUNT;
            DONE:    next_state = ack ? SEARCH0 : DONE;
            default: next_state = SEARCH0;
        endcase
    end

    // Outputs driven combinationally from current state to reduce glitches and registers
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule
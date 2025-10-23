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
    typedef enum logic [6:0] {
        SEARCH0 = 7'b0000001,
        SEARCH1 = 7'b0000010,
        SEARCH2 = 7'b0000100,
        SEARCH3 = 7'b0001000,
        SHIFT   = 7'b0010000,
        COUNT   = 7'b0100000,
        DONE    = 7'b1000000
    } state_t;

    state_t state, state_next;

    reg [1:0] shift_count;

    // Combinational logic for next state
    always_comb begin
        state_next = state; // default hold
        case (state)
            SEARCH0: state_next = data ? SEARCH1 : SEARCH0;
            SEARCH1: state_next = data ? SEARCH2 : SEARCH0;
            SEARCH2: state_next = (~data) ? SEARCH3 : SEARCH2; // remain in SEARCH2 on '1' for overlapping
            SEARCH3: state_next = data ? SHIFT : SEARCH0;
            SHIFT:   state_next = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT:   state_next = done_counting ? DONE : COUNT;
            DONE:    state_next = ack ? SEARCH0 : DONE;
            default: state_next = SEARCH0;
        endcase
    end

    // Sequential logic for state and shift counter
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= state_next;
            if (state == SHIFT)
                shift_count <= shift_count + 1'b1;
            else
                shift_count <= 2'd0;
        end
    end

    // Outputs tied directly to state bits (Moore outputs)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule
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

    // FSM state encoding with localparam for clarity
    localparam [2:0]
        SEARCH0 = 3'd0, // no bits matched
        SEARCH1 = 3'd1, // matched '1'
        SEARCH2 = 3'd2, // matched '11'
        SEARCH3 = 3'd3, // matched '110'
        SHIFT   = 3'd4, // shifting in 4 bits
        COUNT   = 3'd5, // counting in progress
        DONE    = 3'd6; // done, waiting for ack

    reg [2:0] state, next_state;
    reg [1:0] shift_count; // counts shift cycles 0..3

    // Sequential logic: state and shift_count with synchronous active-high reset
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

    // Next-state combinational logic implementing embedded pattern detection with overlap
    always @(*) begin
        case (state)
            SEARCH0: 
                next_state = (data) ? SEARCH1 : SEARCH0;

            SEARCH1: 
                next_state = (data) ? SEARCH2 : SEARCH0;

            SEARCH2: 
                // If input '0', go to SEARCH3; if '1', remain in SEARCH2 (overlap detection)
                next_state = (~data) ? SEARCH3 : SEARCH2;

            SEARCH3: 
                // Final bit '1' completes pattern and start SHIFT; else restart
                next_state = (data) ? SHIFT : SEARCH0;

            SHIFT:   
                // After 4 shift cycles (0..3), move to COUNT
                next_state = (shift_count == 2'd3) ? COUNT : SHIFT;

            COUNT:   
                // Wait for done_counting signal
                next_state = (done_counting) ? DONE : COUNT;

            DONE:    
                // Wait for user acknowledgment
                next_state = (ack) ? SEARCH0 : DONE;

            default:
                next_state = SEARCH0;
        endcase
    end

    // Moore outputs: combinational from current state
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule
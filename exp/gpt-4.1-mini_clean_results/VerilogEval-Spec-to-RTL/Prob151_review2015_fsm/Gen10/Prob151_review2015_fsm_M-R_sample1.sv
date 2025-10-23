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

    // State encoding: expand SHIFT into 4 substates SHIFT0..SHIFT3
    localparam SEARCH0 = 4'd0; // no bits matched
    localparam SEARCH1 = 4'd1; // matched '1'
    localparam SEARCH2 = 4'd2; // matched '11'
    localparam SEARCH3 = 4'd3; // matched '110'
    localparam SHIFT0  = 4'd4; // shift cycle 0
    localparam SHIFT1  = 4'd5; // shift cycle 1
    localparam SHIFT2  = 4'd6; // shift cycle 2
    localparam SHIFT3  = 4'd7; // shift cycle 3
    localparam COUNT   = 4'd8; // waiting for counting to finish
    localparam DONE    = 4'd9; // done, waiting for ack

    reg [3:0] state, next_state;

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            SEARCH0: next_state = (data) ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = (data) ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = (~data) ? SEARCH3 : SEARCH2;
            SEARCH3: next_state = (data) ? SHIFT0 : SEARCH0;

            SHIFT0:  next_state = SHIFT1;
            SHIFT1:  next_state = SHIFT2;
            SHIFT2:  next_state = SHIFT3;
            SHIFT3:  next_state = COUNT;

            COUNT:   next_state = (done_counting) ? DONE : COUNT;
            DONE:    next_state = (ack) ? SEARCH0 : DONE;

            default: next_state = SEARCH0;
        endcase
    end

    // Output logic (Moore outputs)
    assign shift_ena = (state == SHIFT0) || (state == SHIFT1) || (state == SHIFT2) || (state == SHIFT3);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule
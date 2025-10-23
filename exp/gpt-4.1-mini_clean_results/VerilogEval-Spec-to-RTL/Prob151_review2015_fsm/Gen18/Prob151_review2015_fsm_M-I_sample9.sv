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

    // One-hot state encoding (7 states)
    localparam SEARCH0 = 7'b0000001; // no bits matched yet
    localparam SEARCH1 = 7'b0000010; // matched '1'
    localparam SEARCH2 = 7'b0000100; // matched '11'
    localparam SEARCH3 = 7'b0001000; // matched '110'
    localparam SHIFT   = 7'b0010000; // shifting in 4 bits
    localparam COUNT   = 7'b0100000; // counting in progress
    localparam DONE    = 7'b1000000; // done, waiting for ack

    reg [6:0] state, next_state;
    reg [1:0] shift_count;

    // State and shift_count registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // shift_count increments only in SHIFT state
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;

            // Registered outputs updated based on next_state (Moore outputs)
            shift_ena <= (next_state == SHIFT);
            counting  <= (next_state == COUNT);
            done      <= (next_state == DONE);
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            SEARCH0: next_state = (data) ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = (data) ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = (~data) ? SEARCH3 : SEARCH2; // expect '0'
            SEARCH3: next_state = (data) ? SHIFT : SEARCH0;   // expect '1'
            SHIFT:   next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT:   next_state = done_counting ? DONE : COUNT;
            DONE:    next_state = ack ? SEARCH0 : DONE;
            default: next_state = SEARCH0;
        endcase
    end

endmodule
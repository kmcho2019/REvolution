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

    // FSM states (binary encoded)
    localparam SEARCH0 = 3'd0; // no match yet
    localparam SEARCH1 = 3'd1; // matched '1'
    localparam SEARCH2 = 3'd2; // matched '11'
    localparam SEARCH3 = 3'd3; // matched '110'
    localparam SHIFT   = 3'd4; // shifting delay bits (4 cycles)
    localparam COUNT   = 3'd5; // counting delay
    localparam DONE    = 3'd6; // done, waiting for ack

    reg [2:0] state, next_state;
    reg [1:0] shift_count, next_shift_count;

    // Combinational next state logic
    always @(*) begin
        case (state)
            SEARCH0: next_state = data ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = data ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = (~data) ? SEARCH3 : SEARCH2;
            SEARCH3: next_state = data ? SHIFT : SEARCH0;
            SHIFT:   next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT:   next_state = done_counting ? DONE : COUNT;
            DONE:    next_state = ack ? SEARCH0 : DONE;
            default: next_state = SEARCH0;
        endcase
    end

    // Combinational next shift_count logic
    always @(*) begin
        if (state == SHIFT)
            next_shift_count = shift_count + 2'd1;
        else
            next_shift_count = 2'd0;
    end

    // Sequential logic: state and shift_count registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            shift_count <= next_shift_count;
        end
    end

    // Moore outputs based on current state
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule
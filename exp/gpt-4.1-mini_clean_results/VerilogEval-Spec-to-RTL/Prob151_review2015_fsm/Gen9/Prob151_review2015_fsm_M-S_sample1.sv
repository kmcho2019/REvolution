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

    // State encoding
    localparam SEARCH0 = 3'd0; // no bits matched
    localparam SEARCH1 = 3'd1; // matched '1'
    localparam SEARCH2 = 3'd2; // matched '11'
    localparam SEARCH3 = 3'd3; // matched '110'
    localparam SHIFT   = 3'd4; // shifting in 4 bits
    localparam COUNT   = 3'd5; // waiting for counting to finish
    localparam DONE    = 3'd6; // done, waiting for ack

    reg [2:0] state, next_state;
    reg [1:0] shift_count; // counts 0 to 3 during shift

    // State register and shift_count update
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

    // Next state logic
    always @(*) begin
        case (state)
            SEARCH0: next_state = (data) ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = (data) ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = (~data) ? SEARCH3 : SEARCH2;
            SEARCH3: next_state = (data) ? SHIFT : SEARCH0;
            SHIFT:   next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT:   next_state = (done_counting) ? DONE : COUNT;
            DONE:    next_state = (ack) ? SEARCH0 : DONE;
            default: next_state = SEARCH0;
        endcase
    end

    // Output logic (Moore outputs)
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule
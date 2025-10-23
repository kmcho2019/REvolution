module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

    // State encoding as parameters
    localparam [2:0]
        SEARCH0 = 3'd0, // no bits matched
        SEARCH1 = 3'd1, // matched '1'
        SEARCH2 = 3'd2, // matched '11'
        SEARCH3 = 3'd3, // matched '110'
        SHIFT   = 3'd4, // shifting in 4 bits
        COUNT   = 3'd5, // waiting for counting to finish
        DONE    = 3'd6; // done, waiting for ack

    reg [2:0] state, next_state;

    reg [1:0] shift_count;

    // Sequential logic: state and shift_count update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 2'b01;
            else
                shift_count <= 2'b00;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            SEARCH0: next_state = (data) ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = (data) ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = (~data) ? SEARCH3 : SEARCH2;
            SEARCH3: next_state = (data) ? SHIFT : SEARCH0;
            SHIFT:   next_state = (shift_count == 2'b11) ? COUNT : SHIFT;
            COUNT:   next_state = (done_counting) ? DONE : COUNT;
            DONE:    next_state = (ack) ? SEARCH0 : DONE;
            default: next_state = SEARCH0;
        endcase
    end

    // Output combinational assignments (Moore outputs)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule
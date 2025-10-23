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

    // State encoding (3-bit binary)
    localparam [2:0]
        SEARCH0 = 3'd0,
        SEARCH1 = 3'd1,
        SEARCH2 = 3'd2,
        SEARCH3 = 3'd3,
        SHIFT   = 3'd4,
        COUNT   = 3'd5,
        DONE    = 3'd6;

    reg [2:0] state, next_state;
    reg [1:0] shift_count;

    // State and counter registers with synchronous reset
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

    // Next state combinational logic
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

    // Output assignments based on current state
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule
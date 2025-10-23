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
    localparam SEARCH0 = 7'b0000001;
    localparam SEARCH1 = 7'b0000010;
    localparam SEARCH2 = 7'b0000100;
    localparam SEARCH3 = 7'b0001000;
    localparam SHIFT   = 7'b0010000;
    localparam COUNT   = 7'b0100000;
    localparam DONE    = 7'b1000000;

    reg [6:0] state, next_state;
    reg [1:0] shift_count, next_shift_count;

    // Next state combinational logic
    always @(*) begin
        casez (state)
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

    // Shift count next value
    always @(*) begin
        if (state == SHIFT)
            next_shift_count = shift_count + 2'd1;
        else
            next_shift_count = 2'd0;
    end

    // State and shift_count registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            shift_count <= next_shift_count;
        end
    end

    // Outputs as combinational assigns (Moore outputs)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule
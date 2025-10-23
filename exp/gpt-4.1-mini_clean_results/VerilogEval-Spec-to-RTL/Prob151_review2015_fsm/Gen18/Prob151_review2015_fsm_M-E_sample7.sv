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

    // One-hot state encoding
    localparam SEARCH0 = 7'd1 << 0; // no bits matched yet
    localparam SEARCH1 = 7'd1 << 1; // matched '1'
    localparam SEARCH2 = 7'd1 << 2; // matched '11'
    localparam SEARCH3 = 7'd1 << 3; // matched '110'
    localparam SHIFT   = 7'd1 << 4; // shifting in 4 bits
    localparam COUNT   = 7'd1 << 5; // counting
    localparam DONE    = 7'd1 << 6; // done, waiting ack

    reg [6:0] state, next_state;
    reg [2:0] shift_count; // counts 0..3 during SHIFT

    // State and shift_count registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            if (state == SHIFT)
                shift_count <= shift_count + 3'd1;
            else
                shift_count <= 3'd0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            SEARCH0: next_state = (data) ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = (data) ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = (~data) ? SEARCH3 : SEARCH2; // expect 0
            SEARCH3: next_state = (data) ? SHIFT : SEARCH0;   // expect 1, start shift
            SHIFT:   next_state = (shift_count == 3'd3) ? COUNT : SHIFT;
            COUNT:   next_state = done_counting ? DONE : COUNT;
            DONE:    next_state = ack ? SEARCH0 : DONE;
            default: next_state = SEARCH0;
        endcase
    end

    // Output logic (Moore outputs)
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;
        end else begin
            shift_ena <= (state == SHIFT);
            counting  <= (state == COUNT);
            done      <= (state == DONE);
        end
    end

endmodule
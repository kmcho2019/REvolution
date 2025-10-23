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

    // One-hot state encoding (7 states)
    localparam SEARCH0 = 7'b0000001;
    localparam SEARCH1 = 7'b0000010;
    localparam SEARCH2 = 7'b0000100;
    localparam SEARCH3 = 7'b0001000;
    localparam SHIFT   = 7'b0010000;
    localparam COUNT   = 7'b0100000;
    localparam DONE    = 7'b1000000;

    reg [6:0] state, next_state;

    reg [1:0] shift_count;

    // Sequential logic: state and shift_count update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;
            // Enable shift_count only in SHIFT state
            if (state == SHIFT)
                shift_count <= shift_count + 2'b01;
            else
                shift_count <= 2'b00;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (1'b1) // one-hot encoded state decoding style
            state[0]: // SEARCH0
                next_state = data ? SEARCH1 : SEARCH0;
            state[1]: // SEARCH1
                next_state = data ? SEARCH2 : SEARCH0;
            state[2]: // SEARCH2
                next_state = (~data) ? SEARCH3 : SEARCH2;
            state[3]: // SEARCH3
                next_state = data ? SHIFT : SEARCH0;
            state[4]: // SHIFT
                next_state = (shift_count == 2'b11) ? COUNT : SHIFT;
            state[5]: // COUNT
                next_state = done_counting ? DONE : COUNT;
            state[6]: // DONE
                next_state = ack ? SEARCH0 : DONE;
            default: // safe fallback
                next_state = SEARCH0;
        endcase
    end

    // Output combinational assignments (Moore outputs)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule
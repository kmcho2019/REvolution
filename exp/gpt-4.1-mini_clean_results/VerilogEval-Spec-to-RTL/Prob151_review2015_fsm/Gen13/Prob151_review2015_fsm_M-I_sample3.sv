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

    // One-hot encoded states (7 states)
    localparam
        SEARCH0 = 7'b0000001,
        SEARCH1 = 7'b0000010,
        SEARCH2 = 7'b0000100,
        SEARCH3 = 7'b0001000,
        SHIFT   = 7'b0010000,
        COUNT   = 7'b0100000,
        DONE    = 7'b1000000;

    reg [6:0] state, next_state;

    reg [1:0] shift_count;
    wire shift_count_done = (shift_count == 2'd3);

    // Sequential logic: state register and shift_count with synchronous reset
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

    // Next state combinational logic with one-hot states
    always @(*) begin
        // default next state: hold current state
        next_state = state;

        case (1'b1)
            state[0]: // SEARCH0
                next_state = data ? SEARCH1 : SEARCH0;
            state[1]: // SEARCH1
                next_state = data ? SEARCH2 : SEARCH0;
            state[2]: // SEARCH2
                next_state = (~data) ? SEARCH3 : SEARCH2;
            state[3]: // SEARCH3
                next_state = data ? SHIFT : SEARCH0;
            state[4]: // SHIFT
                next_state = shift_count_done ? COUNT : SHIFT;
            state[5]: // COUNT
                next_state = done_counting ? DONE : COUNT;
            state[6]: // DONE
                next_state = ack ? SEARCH0 : DONE;
            default:
                next_state = SEARCH0;
        endcase
    end

    // Outputs: directly from one-hot states, simple wire assignments
    assign shift_ena = state[4];  // SHIFT
    assign counting  = state[5];  // COUNT
    assign done      = state[6];  // DONE

endmodule
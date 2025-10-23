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

    // One-hot FSM states for simpler next-state logic and better timing
    localparam [6:0]
        SEARCH0 = 7'b0000001,
        SEARCH1 = 7'b0000010,
        SEARCH2 = 7'b0000100,
        SEARCH3 = 7'b0001000,
        SHIFT   = 7'b0010000,
        COUNT   = 7'b0100000,
        DONE    = 7'b1000000;

    reg [6:0] state, next_state;
    reg [2:0] shift_count; // counts from 0 to 3 for 4 cycles

    // State and shift_count sequential logic with synchronous reset
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

    // Next state combinational logic with simplified conditions for one-hot encoding
    always @(*) begin
        case (1'b1) // one-hot encoded states
            state[0]: // SEARCH0
                next_state = data ? SEARCH1 : SEARCH0;

            state[1]: // SEARCH1
                next_state = data ? SEARCH2 : SEARCH0;

            state[2]: // SEARCH2
                next_state = (~data) ? SEARCH3 : SEARCH2;

            state[3]: // SEARCH3
                next_state = data ? SHIFT : SEARCH0;

            state[4]: // SHIFT
                next_state = (shift_count == 3'd3) ? COUNT : SHIFT;

            state[5]: // COUNT
                next_state = done_counting ? DONE : COUNT;

            state[6]: // DONE
                next_state = ack ? SEARCH0 : DONE;

            default:
                next_state = SEARCH0;
        endcase
    end

    // Moore outputs based on current state (one-hot)
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule
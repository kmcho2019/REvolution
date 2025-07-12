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
    localparam [6:0]
        SEARCH0 = 7'b0000001,
        SEARCH1 = 7'b0000010,
        SEARCH2 = 7'b0000100,
        SEARCH3 = 7'b0001000,
        SHIFT   = 7'b0010000,
        COUNT   = 7'b0100000,
        DONE    = 7'b1000000;

    reg [6:0] state, next_state;

    // Shift register counter for 4 cycles in SHIFT state (3 bits, shifted left)
    // When MSB is '1', 4 cycles have elapsed
    reg [2:0] shift_count_reg;

    // Sequential logic: state and shift_count_reg update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count_reg <= 3'b000;
        end else begin
            state <= next_state;
            if (state == SHIFT)
                shift_count_reg <= {shift_count_reg[1:0], 1'b1}; // shift in 1's each cycle
            else
                shift_count_reg <= 3'b000;
        end
    end

    // Next state combinational logic (Moore FSM)
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH0: begin
                if (data)
                    next_state = SEARCH1;
                else
                    next_state = SEARCH0;
            end
            SEARCH1: begin
                if (data)
                    next_state = SEARCH2;
                else
                    next_state = SEARCH0;
            end
            SEARCH2: begin
                if (~data)
                    next_state = SEARCH3;
                else
                    next_state = SEARCH2; // remain SEARCH2 for overlapping pattern detection
            end
            SEARCH3: begin
                if (data)
                    next_state = SHIFT;
                else
                    next_state = SEARCH0;
            end
            SHIFT: begin
                if (shift_count_reg[2] == 1'b1) // 4 cycles done when MSB set
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                if (ack)
                    next_state = SEARCH0;
                else
                    next_state = DONE;
            end
            default: next_state = SEARCH0;
        endcase
    end

    // Outputs combinationally driven by current state (Moore outputs)
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule
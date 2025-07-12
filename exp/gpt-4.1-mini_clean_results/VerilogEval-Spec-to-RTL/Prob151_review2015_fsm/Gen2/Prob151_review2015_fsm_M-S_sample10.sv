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
    typedef enum logic [1:0] {
        SEARCH = 2'd0,
        SHIFT  = 2'd1,
        COUNT  = 2'd2,
        DONE   = 2'd3
    } state_t;

    state_t state, next_state;

    // 4-bit shift register for pattern detection
    reg [3:0] data_shift;

    // Counter for SHIFT cycles (0 to 3)
    reg [1:0] shift_count;

    // Shift register and state register update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            data_shift <= 4'b0000;
            shift_count <= 2'd0;
        end else begin
            data_shift <= {data_shift[2:0], data}; // shift in new data bit
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (data_shift == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;
            end
            SHIFT: begin
                if (shift_count == 2'd3)
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
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end
            default: next_state = SEARCH;
        endcase
    end

    // Outputs combinational logic
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule
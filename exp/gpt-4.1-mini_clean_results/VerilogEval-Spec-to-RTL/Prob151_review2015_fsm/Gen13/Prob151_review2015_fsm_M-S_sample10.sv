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

    // States definition
    typedef enum logic [1:0] {
        SEARCH = 2'd0,
        SHIFT  = 2'd1,
        COUNT  = 2'd2,
        DONE   = 2'd3
    } state_t;

    state_t state, next_state;
    reg [3:0] shift_reg;     // For detecting pattern 1101
    reg [2:0] shift_count;   // 4-cycle counter for shift_ena (3 bits for safety)

    // Next state and outputs combinational logic
    always @(*) begin
        // Default assignments
        next_state = state;
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case(state)
            SEARCH: begin
                counting = 1'b0;
                done = 1'b0;
                shift_ena = 1'b0;
                // If pattern detected, go to SHIFT
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 3'd3) // After 4 cycles (0 to 3)
                    next_state = COUNT;
            end
            COUNT: begin
                counting = 1'b1;
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                done = 1'b1;
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'd0;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            // Shift pattern detection register only in SEARCH state
            if (state == SEARCH) begin
                shift_reg <= {shift_reg[2:0], data};
                shift_count <= 3'd0;
            end else if (state == SHIFT) begin
                shift_count <= shift_count + 3'd1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

endmodule
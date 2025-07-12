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

    // One-hot state encoding parameters
    localparam SEARCH    = 7'b000_0001;
    localparam SHIFT     = 7'b000_0010;
    localparam COUNT     = 7'b000_0100;
    localparam DONE      = 7'b000_1000;

    // Because original FSM had 7 states, but pattern detection is handled separately,
    // here we collapse SEARCH0..SEARCH3 into a single SEARCH state

    // Shift register to detect pattern 1101 (4 bits)
    reg [3:0] pattern_shift_reg;

    // State register (one-hot encoded)
    reg [6:0] state, next_state;

    // 2-bit shift counter for SHIFT cycles (0 to 3)
    reg [1:0] shift_count;

    // Pattern detection: shift in the incoming data every clock
    always @(posedge clk) begin
        if (reset)
            pattern_shift_reg <= 4'b0000;
        else
            pattern_shift_reg <= {pattern_shift_reg[2:0], data};
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
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
        // default hold state
        next_state = state;

        case (state)
            SEARCH: begin
                // When pattern 1101 detected, move to SHIFT state
                if (pattern_shift_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;
            end

            SHIFT: begin
                // After 4 cycles in SHIFT, move to COUNT
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end

            COUNT: begin
                // Wait for done_counting
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            DONE: begin
                // Wait for ack, then back to SEARCH
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Outputs as combinational continuous assignments based on one-hot state
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule
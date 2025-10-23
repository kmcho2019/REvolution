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

    // One-hot state encoding (7 bits, one per state)
    localparam SEARCH  = 7'b000_0001;
    localparam SHIFT   = 7'b000_0010;
    localparam COUNT   = 7'b000_0100;
    localparam DONE    = 7'b000_1000;

    // We will store the last 4 bits of data to detect the pattern 1101.
    reg [3:0] shift_reg;

    reg [6:0] state, next_state;

    // 2-bit counter for shift cycles (counts 0..3)
    reg [1:0] shift_count;

    // Update shift_reg with incoming serial data every clock cycle
    always_ff @(posedge clk) begin
        if (reset)
            shift_reg <= 4'b0000;
        else
            shift_reg <= {shift_reg[2:0], data};
    end

    // State register update with synchronous reset
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            // Shift count increments only in SHIFT state
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state combinational logic
    always_comb begin
        next_state = state;

        case (state)
            SEARCH: begin
                // Detect pattern "1101" in shift_reg
                if (shift_reg == 4'b1101)
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

    // Outputs driven by combinational assign statements based on state
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule
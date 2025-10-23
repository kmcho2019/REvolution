module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        SEARCH   = 2'b00,
        SHIFT    = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;      // continuously shift data for pattern detection
    reg [1:0] shift_count;    // count shift cycles (0 to 3)

    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic: state, shift_reg, shift_count
    always @(posedge clk) begin
        if (reset) begin
            state       <= SEARCH;
            shift_reg   <= 4'b0000;
            shift_count <= 2'd0;
            shift_ena   <= 1'b0;
            counting    <= 1'b0;
            done        <= 1'b0;
        end else begin
            state <= next_state;

            // Always shift in data on every clock edge for pattern detection
            shift_reg <= {shift_reg[2:0], data};

            // Manage shift_count in SHIFT state only
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;

            // Output signals driven directly from state
            shift_ena <= (next_state == SHIFT) || (state == SHIFT);
            counting  <= (state == COUNTING);
            done      <= (state == DONE);
        end
    end

    // Next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (shift_reg == PATTERN)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_count == 2'd3) // after 4 cycles (0 to 3)
                    next_state = COUNTING;
            end
            COUNTING: begin
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

endmodule
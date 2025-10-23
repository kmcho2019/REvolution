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
    localparam IDLE     = 2'd0;
    localparam SHIFT    = 2'd1;
    localparam COUNTING = 2'd2;
    localparam DONE     = 2'd3;

    reg [1:0] state, next_state;

    reg [3:0] shift_reg;  // Continuous shift register for pattern detection
    reg [2:0] shift_count; // counts shift cycles (0 to 3)

    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic: state, shift register, shift_count
    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            shift_reg   <= 4'b0000;
            shift_count <= 3'd0;
            shift_ena   <= 1'b0;
            counting    <= 1'b0;
            done        <= 1'b0;
        end else begin
            // Always shift in data each clock for pattern detection
            shift_reg <= {shift_reg[2:0], data};

            state <= next_state;

            // Update outputs based on current state
            shift_ena <= (state == SHIFT);
            counting  <= (state == COUNTING);
            done      <= (state == DONE);

            case (state)
                IDLE: begin
                    shift_count <= 3'd0;  // clear shift_count in IDLE
                end
                SHIFT: begin
                    shift_count <= shift_count + 3'd1;
                end
                default: begin
                    shift_count <= 3'd0;  // clear in COUNTING and DONE
                end
            endcase
        end
    end

    // Next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (shift_reg == PATTERN)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_count == 3'd3) // After 4 cycles (0 to 3)
                    next_state = COUNTING;
            end
            COUNTING: begin
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

endmodule
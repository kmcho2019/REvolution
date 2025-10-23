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
        IDLE     = 2'b00,
        SHIFT    = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11
    } state_t;
    state_t state, next_state;

    reg [3:0] shift_reg;    // To detect pattern 1101
    reg [2:0] shift_count;  // To count exactly 4 shift cycles (0 to 3)

    // Sequential logic: state, shift register and shift counter update
    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            shift_reg   <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            // Shift in data every clock cycle to detect pattern continuously
            shift_reg <= {shift_reg[2:0], data};

            // Manage shift_count only in SHIFT state, reset otherwise
            if (state == SHIFT) begin
                shift_count <= shift_count + 1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    // Combinational next state and output logic based on registered state and inputs
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;
        next_state = state;

        case(state)
            IDLE: begin
                // When pattern 1101 detected after shifting in new data, move to SHIFT
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                shift_ena = 1'b1;
                // After 4 shift cycles (shift_count = 3), move to COUNTING
                if (shift_count == 3'd3) begin
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
                counting = 1'b1;
                if (done_counting) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule
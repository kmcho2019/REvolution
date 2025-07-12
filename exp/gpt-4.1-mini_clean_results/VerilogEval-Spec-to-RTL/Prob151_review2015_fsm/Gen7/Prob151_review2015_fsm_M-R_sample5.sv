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

    // --- Pattern detection FSM for 1101 ---
    // States encode how many bits matched so far:
    // 0 - no match yet
    // 1 - matched '1'
    // 2 - matched '11'
    // 3 - matched '110'
    reg [1:0] pd_state, pd_state_next;
    reg pattern_detected_reg;

    always @(*) begin
        pattern_detected_reg = 1'b0;
        case (pd_state)
            2'd0: begin
                if (data == 1'b1)
                    pd_state_next = 2'd1;
                else
                    pd_state_next = 2'd0;
            end
            2'd1: begin
                if (data == 1'b1)
                    pd_state_next = 2'd2;
                else
                    pd_state_next = 2'd0;
            end
            2'd2: begin
                if (data == 1'b0)
                    pd_state_next = 2'd3;
                else
                    // Stay in state 2 to handle overlapping pattern "111..."
                    pd_state_next = 2'd2;
            end
            2'd3: begin
                if (data == 1'b1) begin
                    pd_state_next = 2'd1; // allow overlapping patterns starting again with '1'
                    pattern_detected_reg = 1'b1; // pattern 1101 detected at this bit
                end else begin
                    pd_state_next = 2'd0;
                end
            end
            default: pd_state_next = 2'd0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            pd_state <= 2'd0;
            pattern_detected_reg <= 1'b0;
        end else begin
            pd_state <= pd_state_next;
            // Register pattern_detected as pulse synchronous to clk
            if (pattern_detected_reg)
                pattern_detected_reg <= 1'b1;
            else
                pattern_detected_reg <= 1'b0;
        end
    end

    wire pattern_detected = pattern_detected_reg;

    // --- Main FSM for timer control ---
    typedef enum reg [1:0] {IDLE=2'd0, SHIFT=2'd1, COUNT=2'd2, DONE=2'd3} state_t;
    reg [1:0] state, state_next;

    // 2-bit shift counter (counts 0 to 3)
    reg [1:0] shift_count;
    wire shift_count_max = (shift_count == 2'd3);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'd0;
        end else begin
            state <= state_next;
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    always @(*) begin
        state_next = state;
        case (state)
            IDLE: begin
                if (pattern_detected)
                    state_next = SHIFT;
            end
            SHIFT: begin
                if (shift_count_max)
                    state_next = COUNT;
            end
            COUNT: begin
                if (done_counting)
                    state_next = DONE;
            end
            DONE: begin
                if (ack)
                    state_next = IDLE;
            end
            default: state_next = IDLE;
        endcase
    end

    // Outputs synchronous to state
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;
        end else begin
            shift_ena <= (state == SHIFT);
            counting  <= (state == COUNT);
            done      <= (state == DONE);
        end
    end

endmodule
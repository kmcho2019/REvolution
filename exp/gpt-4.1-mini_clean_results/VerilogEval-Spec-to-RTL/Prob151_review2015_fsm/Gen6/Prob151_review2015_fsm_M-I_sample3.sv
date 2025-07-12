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

    // Pattern detect states for 1101 detection
    localparam PD_IDLE = 2'd0;
    localparam PD_1    = 2'd1; // matched '1'
    localparam PD_11   = 2'd2; // matched '11'
    localparam PD_110  = 2'd3; // matched '110'

    reg [1:0] pd_state, pd_next_state;
    reg pattern_detected;

    // Pattern detector FSM
    always @(posedge clk) begin
        if (reset) begin
            pd_state <= PD_IDLE;
            pattern_detected <= 1'b0;
        end else begin
            pd_state <= pd_next_state;

            // Pulse pattern_detected high for one cycle only when pattern recognized
            if (pd_next_state == PD_IDLE && pd_state == PD_110 && data == 1'b1) begin
                // Pattern 1101 detected on current bit
                pattern_detected <= 1'b1;
            end else begin
                pattern_detected <= 1'b0;
            end
        end
    end

    // Next state logic for pattern detection FSM
    always @(*) begin
        case (pd_state)
            PD_IDLE:  pd_next_state = (data) ? PD_1 : PD_IDLE;
            PD_1:     pd_next_state = (data) ? PD_11 : PD_IDLE;
            PD_11:    pd_next_state = (data) ? PD_11 : PD_110; // expecting '0'
            PD_110:   pd_next_state = (data) ? PD_IDLE : PD_IDLE; // expecting '1' to detect pattern
            default:  pd_next_state = PD_IDLE;
        endcase
    end

    // FSM states for main timer controller
    localparam IDLE  = 3'd0;
    localparam SHIFT = 3'd1;
    localparam COUNT = 3'd2;
    localparam DONE  = 3'd3;

    reg [2:0] state, next_state;

    // 2-bit counter for SHIFT cycles (0 to 3)
    reg [1:0] shift_count;

    // FSM state register and shift_count
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (pattern_detected)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
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
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Outputs synchronous to FSM state
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
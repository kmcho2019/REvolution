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

    // Sequence detector states for pattern 1101 detection
    localparam SEQ_IDLE  = 2'd0;
    localparam SEQ_G1    = 2'd1;  // detected first '1'
    localparam SEQ_G11   = 2'd2;  // detected "11"
    localparam SEQ_G110  = 2'd3;  // detected "110"

    reg [1:0] seq_state, seq_next;

    // Main FSM states
    localparam ST_IDLE      = 3'd0;
    localparam ST_SHIFT_4   = 3'd1;
    localparam ST_COUNTING  = 3'd2;
    localparam ST_DONE      = 3'd3;

    reg [2:0] state, next_state;

    reg [2:0] shift_cnt;  // counts 0 to 3 during shifting

    // Sequence detector for pattern 1101 on serial data input
    always @(posedge clk) begin
        if (reset) begin
            seq_state <= SEQ_IDLE;
        end else if (state == ST_IDLE) begin
            seq_state <= seq_next;
        end else begin
            // Hold seq_state in other FSM states to avoid false detections
            seq_state <= SEQ_IDLE;
        end
    end

    always @(*) begin
        seq_next = seq_state;
        case(seq_state)
            SEQ_IDLE:  seq_next = (data) ? SEQ_G1 : SEQ_IDLE;
            SEQ_G1:    seq_next = (data) ? SEQ_G11 : SEQ_IDLE;
            SEQ_G11:   seq_next = (data) ? SEQ_G11 : SEQ_G110;
            SEQ_G110:  seq_next = (data) ? SEQ_G1 : SEQ_IDLE;
            default:   seq_next = SEQ_IDLE;
        endcase
    end

    // Detect full pattern 1101 when in SEQ_G110 and data==1'b1 for next input?
    // Pattern is 1 1 0 1: detected when seq_state == SEQ_G110 and data == 1
    wire pattern_detected = (seq_state == SEQ_G110) && (data == 1'b1);

    // FSM state transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= ST_IDLE;
            shift_cnt <= 3'd0;
        end else begin
            state <= next_state;

            if (state == ST_SHIFT_4) begin
                shift_cnt <= shift_cnt + 1'b1;
            end else begin
                shift_cnt <= 3'd0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case(state)
            ST_IDLE: begin
                if (pattern_detected)
                    next_state = ST_SHIFT_4;
            end
            ST_SHIFT_4: begin
                if (shift_cnt == 3'd3)
                    next_state = ST_COUNTING;
            end
            ST_COUNTING: begin
                if (done_counting)
                    next_state = ST_DONE;
            end
            ST_DONE: begin
                if (ack)
                    next_state = ST_IDLE;
            end
            default: next_state = ST_IDLE;
        endcase
    end

    // Outputs: Moore style - depend only on current state
    always @(*) begin
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case(state)
            ST_SHIFT_4: shift_ena = 1'b1;
            ST_COUNTING: counting = 1'b1;
            ST_DONE:     done     = 1'b1;
        endcase
    end

endmodule
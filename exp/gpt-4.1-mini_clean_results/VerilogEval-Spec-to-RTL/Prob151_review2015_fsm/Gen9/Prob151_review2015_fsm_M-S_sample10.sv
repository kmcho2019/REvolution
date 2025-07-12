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
    localparam IDLE      = 2'd0;
    localparam SHIFT_4   = 2'd1;
    localparam COUNTING  = 2'd2;
    localparam DONE      = 2'd3;

    reg [1:0] state, next_state;
    reg [3:0] shift_reg;
    reg [1:0] shift_cnt;

    // Pattern detection by checking shift_reg plus current data bit
    wire pattern_detected = (shift_reg == 4'b1101);

    // Update shift register every clock cycle in IDLE state only
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'd0;
            shift_cnt <= 2'd0;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                // Shift in new data bit
                shift_reg <= {shift_reg[2:0], data};
            end

            if (state == SHIFT_4) begin
                shift_cnt <= shift_cnt + 1'b1;
            end else begin
                shift_cnt <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_detected)
                    next_state = SHIFT_4;
            end
            SHIFT_4: begin
                if (shift_cnt == 2'd3)
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

    // Outputs (Moore machine)
    always @(*) begin
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            SHIFT_4:   shift_ena = 1'b1;
            COUNTING:  counting  = 1'b1;
            DONE:      done      = 1'b1;
        endcase
    end

endmodule
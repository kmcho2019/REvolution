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

    // FSM states
    localparam IDLE      = 2'd0;
    localparam SHIFT_4   = 2'd1;
    localparam COUNTING  = 2'd2;
    localparam DONE      = 2'd3;

    reg [1:0] state, next_state;
    reg [1:0] shift_cnt;

    reg [3:0] shift_reg;

    // Shift in data to detect 1101 pattern
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
        end else if (state == IDLE) begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 2'd0;
        end else begin
            state <= next_state;

            if (state == SHIFT_4)
                shift_cnt <= shift_cnt + 1'b1;
            else
                shift_cnt <= 2'd0;
        end
    end

    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (shift_reg == 4'b1101)
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

    // Outputs - Moore type
    always @(*) begin
        shift_ena = (state == SHIFT_4);
        counting  = (state == COUNTING);
        done      = (state == DONE);
    end

endmodule
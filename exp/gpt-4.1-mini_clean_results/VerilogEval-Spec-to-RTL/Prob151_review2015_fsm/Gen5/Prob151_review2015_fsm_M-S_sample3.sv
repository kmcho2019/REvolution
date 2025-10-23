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

    // States
    localparam IDLE     = 2'd0;
    localparam SHIFTING = 2'd1;
    localparam COUNTING = 2'd2;
    localparam DONE     = 2'd3;

    reg [1:0] state, next_state;
    reg [3:0] shift_reg;
    reg [2:0] shift_cnt; // Counts 0 to 3 for 4 shift cycles

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 4'd0;
            shift_cnt <= 3'd0;
        end else begin
            // Shift in data each cycle
            shift_reg <= {shift_reg[2:0], data};
            state <= next_state;

            if (state == SHIFTING)
                shift_cnt <= shift_cnt + 1'b1;
            else
                shift_cnt <= 3'd0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // When pattern 1101 detected in shift_reg, start shifting
                if (shift_reg == 4'b1101)
                    next_state = SHIFTING;
            end
            SHIFTING: begin
                if (shift_cnt == 3'd3)
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

    // Output logic
    always @(*) begin
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;
        case(state)
            SHIFTING: shift_ena = 1'b1;
            COUNTING: counting  = 1'b1;
            DONE:     done      = 1'b1;
        endcase
    end

endmodule
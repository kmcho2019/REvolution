module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);
    // State encoding
    localparam SEARCH = 2'd0;
    localparam SHIFT  = 2'd1;
    localparam COUNT  = 2'd2;
    localparam DONE   = 2'd3;

    reg [1:0] state, next_state;

    // Shift register to detect pattern 1101
    reg [3:0] shift_reg;

    // Shift counter for the 4 bits to shift in
    reg [2:0] shift_cnt; // 3 bits because max count is 4

    // Sequential logic for state and shift_reg
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'd0;
            shift_cnt <= 3'd0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in new data bit into shift_reg
                    shift_reg <= {shift_reg[2:0], data};
                end
                SHIFT: begin
                    // Continue shifting data
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_cnt < 4)
                        shift_cnt <= shift_cnt + 1;
                end
                default: begin
                    // Nothing to do with shift_reg or shift_cnt
                    shift_cnt <= 0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        // Default outputs and next_state
        shift_ena = 0;
        counting = 0;
        done = 0;
        next_state = state;

        case (state)
            SEARCH: begin
                // Check if pattern 1101 is detected
                // pattern to detect: 4'b1101 = 4'hD
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                shift_ena = 1;
                if (shift_cnt == 4) begin
                    next_state = COUNT;
                end
            end
            COUNT: begin
                counting = 1;
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                done = 1;
                if (ack) begin
                    next_state = SEARCH;
                end
            end
        endcase
    end

endmodule
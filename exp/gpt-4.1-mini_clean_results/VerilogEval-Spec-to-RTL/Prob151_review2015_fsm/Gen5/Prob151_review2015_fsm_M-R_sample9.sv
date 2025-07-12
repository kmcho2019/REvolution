module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // State encoding (one-hot style)
    localparam SEARCH     = 4'b0001;
    localparam SHIFT      = 4'b0010;
    localparam WAIT_COUNT = 4'b0100;
    localparam WAIT_ACK   = 4'b1000;

    reg [3:0] state, next_state;

    // Shift register for pattern detection, always shifts in data every cycle
    reg [3:0] shift_reg;

    // 2-bit counter for 4 cycles in SHIFT state
    reg [1:0] shift_cnt;
    wire shift_cnt_enable = (state == SHIFT);

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold
        case (state)
            SEARCH: begin
                // Pattern detected?
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_cnt == 2'd3)
                    next_state = WAIT_COUNT;
            end
            WAIT_COUNT: begin
                if (done_counting)
                    next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // State register and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
        end else begin
            state <= next_state;
        end
    end

    // Shift register always shifts in data every clock (pattern detection)
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // shift_cnt increments only in SHIFT state, resets otherwise
    always @(posedge clk) begin
        if (reset) begin
            shift_cnt <= 2'd0;
        end else if (shift_cnt_enable) begin
            shift_cnt <= shift_cnt + 1'b1;
        end else begin
            shift_cnt <= 2'd0;
        end
    end

    // Outputs combinationally driven from registered state (Moore outputs)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == WAIT_COUNT);
    assign done      = (state == WAIT_ACK);

endmodule
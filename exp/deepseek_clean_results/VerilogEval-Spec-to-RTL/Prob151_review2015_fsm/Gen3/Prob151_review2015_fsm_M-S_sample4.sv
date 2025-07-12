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
    localparam [2:0]
        IDLE   = 3'b000,
        SHIFT  = 3'b001,
        COUNT  = 3'b010,
        DONE   = 3'b011;

    reg [2:0] state, next_state;
    reg [3:0] pattern;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
        end else begin
            state <= next_state;
            pattern <= {pattern[2:0], data};
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (pattern == 4'b1101) ? SHIFT : IDLE;
            SHIFT: next_state = (pattern[1:0] == 2'b01) ? COUNT : SHIFT; // After 4 shifts
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting = (state == COUNT);
        done = (state == DONE);
    end

endmodule
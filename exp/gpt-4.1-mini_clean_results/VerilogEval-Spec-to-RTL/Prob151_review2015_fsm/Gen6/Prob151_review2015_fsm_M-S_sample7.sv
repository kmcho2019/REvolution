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

    typedef enum logic [1:0] {
        SEARCH = 2'b00,
        SHIFT  = 2'b01,
        WAIT_COUNT = 2'b10,
        WAIT_ACK   = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;
    reg [2:0] shift_count;  // Counts 0..3 for 4 cycles during SHIFT

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            // Shift register updates only in SEARCH
            if (state == SEARCH) begin
                shift_reg <= {shift_reg[2:0], data};
            end

            // Shift count increments only in SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 3'd1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_count == 3'd3)
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

    // Moore outputs
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == WAIT_COUNT);
    assign done      = (state == WAIT_ACK);

endmodule
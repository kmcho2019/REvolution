module TopModule(
    input  wire clk,
    input  wire reset,       // synchronous active-high reset
    output wire shift_ena
);

    // Define states
    localparam IDLE   = 1'b0,
               ENABLE = 1'b1;

    reg state, next_state;
    reg [1:0] count, next_count;  // 2-bit counter counts 0..3 for 4 cycles

    // Sequential logic: state and count update
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            count <= 2'd0;
        end else begin
            state <= next_state;
            count <= next_count;
        end
    end

    // Combinational logic: next state and count
    always @(*) begin
        next_state = state;
        next_count = count;

        case (state)
            IDLE: begin
                // Stay in IDLE forever until reset
                next_count = 2'd0;
            end

            ENABLE: begin
                if (count == 2'd3) begin
                    // After 4 cycles (0 to 3), disable shift_ena
                    next_state = IDLE;
                    next_count = 2'd0;
                end else begin
                    next_count = count + 1'b1;
                end
            end

            default: begin
                next_state = IDLE;
                next_count = 2'd0;
            end
        endcase
    end

    // Output shift_ena asserted in ENABLE state
    assign shift_ena = (state == ENABLE);

endmodule
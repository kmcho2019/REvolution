module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam SHIFT_ENABLE = 1'b1;

    reg state, next_state;
    reg [1:0] count, next_count;

    // Next-state and next-count logic
    always @(*) begin
        next_state = state;
        next_count = count;
        case (state)
            IDLE: begin
                // After reset is released, remain in IDLE
                // No pattern detection logic here, so remain in IDLE
                next_count = 2'd0;
                shift_ena = 1'b0;
            end
            SHIFT_ENABLE: begin
                shift_ena = 1'b1;
                if (count == 2'd1) begin
                    next_state = IDLE;
                    next_count = 2'd0;
                end else begin
                    next_count = count - 1;
                end
            end
            default: begin
                next_state = IDLE;
                next_count = 2'd0;
                shift_ena = 1'b0;
            end
        endcase
    end

    // State and count register update (synchronous reset)
    always @(posedge clk) begin
        if (reset) begin
            state <= SHIFT_ENABLE;
            count <= 2'd4;
        end else begin
            state <= next_state;
            count <= next_count;
        end
    end

endmodule
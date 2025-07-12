module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    // State encoding
    localparam IDLE   = 2'd0;
    localparam ENABLE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;
    reg [1:0] count, next_count;

    // pattern_detected hardwired low (for future extension)
    wire pattern_detected = 1'b0;

    // Combinational next state and count logic
    always @(*) begin
        next_state = state;
        next_count = count;

        case (state)
            IDLE: begin
                if (pattern_detected) begin
                    next_state = ENABLE;
                    next_count = 2'd0;
                end
            end

            ENABLE: begin
                if (count == 2'd3) begin
                    next_state = DONE;
                    next_count = 2'd0;
                end else begin
                    next_state = ENABLE;
                    next_count = count + 1'b1;
                end
            end

            DONE: begin
                if (pattern_detected) begin
                    next_state = ENABLE;
                    next_count = 2'd0;
                end
            end

            default: begin
                next_state = IDLE;
                next_count = 2'd0;
            end
        endcase
    end

    // Sequential logic: state, count, and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            count <= 2'd0;
            shift_ena <= 1'b1;
        end else begin
            state <= next_state;
            count <= next_count;
            // shift_ena asserted in ENABLE state, else zero
            shift_ena <= (next_state == ENABLE) ? 1'b1 : 1'b0;
        end
    end

endmodule
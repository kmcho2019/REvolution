module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    localparam STATE_WAIT   = 2'b00;
    localparam STATE_PASS   = 2'b01; // Before first '1' detected, pass input as is
    localparam STATE_INVERT = 2'b10; // After first '1' detected, output inverted bits

    reg [1:0] state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_WAIT;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            STATE_WAIT: begin
                // Wait until reset is released
                if (!areset)
                    next_state = STATE_PASS;
                else
                    next_state = STATE_WAIT;
            end
            STATE_PASS: begin
                // If input bit x == 1, switch to invert state
                if (x == 1'b1)
                    next_state = STATE_INVERT;
                else
                    next_state = STATE_PASS;
            end
            STATE_INVERT: begin
                // Stay in invert state until reset asserted
                if (areset)
                    next_state = STATE_WAIT;
                else
                    next_state = STATE_INVERT;
            end
            default: next_state = STATE_WAIT;
        endcase
    end

    // Moore output logic (depends on state and input x)
    always @(*) begin
        case(state)
            STATE_WAIT:   z = 1'b0; // Output zero when waiting (could be don't care)
            STATE_PASS:   z = x;    // Output input as is before first '1'
            STATE_INVERT: z = ~x;   // Output inverted input bits after first '1'
            default:      z = 1'b0;
        endcase
    end

endmodule
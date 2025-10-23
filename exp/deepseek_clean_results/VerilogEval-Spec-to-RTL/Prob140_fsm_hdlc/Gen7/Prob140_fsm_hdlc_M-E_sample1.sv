module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum logic [1:0] {
        STATE_NORMAL,
        STATE_DISCARD,
        STATE_FLAG,
        STATE_ERROR
    } state_t;

    state_t current_state, next_state;
    reg [2:0] ones_counter;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_NORMAL;
            ones_counter <= 3'b0;
            {disc, flag, err} <= 3'b0;
        end else begin
            current_state <= next_state;
            
            // Update ones counter
            if (in) begin
                if (ones_counter < 3'b111)
                    ones_counter <= ones_counter + 1;
            end else begin
                ones_counter <= 3'b0;
            end

            // Output logic (registered)
            disc <= (current_state == STATE_DISCARD) && !in;
            flag <= (current_state == STATE_FLAG) && !in;
            err <= (current_state == STATE_ERROR);
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            STATE_NORMAL: begin
                if (ones_counter == 5 && in)
                    next_state = STATE_DISCARD;
                else if (ones_counter == 6 && in)
                    next_state = STATE_FLAG;
                else if (ones_counter >= 7)
                    next_state = STATE_ERROR;
                else
                    next_state = STATE_NORMAL;
            end
            STATE_DISCARD: begin
                if (!in)
                    next_state = STATE_NORMAL;
                else if (ones_counter >= 7)
                    next_state = STATE_ERROR;
                else
                    next_state = STATE_DISCARD;
            end
            STATE_FLAG: begin
                if (!in)
                    next_state = STATE_NORMAL;
                else if (ones_counter >= 7)
                    next_state = STATE_ERROR;
                else
                    next_state = STATE_FLAG;
            end
            STATE_ERROR: begin
                if (!in)
                    next_state = STATE_NORMAL;
                else
                    next_state = STATE_ERROR;
            end
            default: next_state = STATE_NORMAL;
        endcase
    end

endmodule
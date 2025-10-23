module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    // State encoding
    typedef enum logic [1:0] {
        STATE_LOW  = 2'b00,
        STATE_HIGH = 2'b01,
        STATE_EDGE = 2'b10
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= STATE_LOW;
            rise <= 1'b0;
            down <= 1'b0;
        end
        else begin
            current_state <= next_state;
            
            // Output logic (registered)
            case (next_state)
                STATE_EDGE: begin
                    rise <= (current_state == STATE_LOW);
                    down <= (current_state == STATE_HIGH);
                end
                default: begin
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            STATE_LOW: begin
                next_state = a ? STATE_EDGE : STATE_LOW;
            end
            STATE_HIGH: begin
                next_state = a ? STATE_HIGH : STATE_EDGE;
            end
            STATE_EDGE: begin
                next_state = a ? STATE_HIGH : STATE_LOW;
            end
            default: begin
                next_state = STATE_LOW;
            end
        endcase
    end

endmodule
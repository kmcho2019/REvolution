module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    // State encoding
    typedef enum logic [1:0] {
        STABLE_0,
        TRANSITION,
        STABLE_1
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= STABLE_0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            current_state <= next_state;
            
            // Registered outputs
            rise <= (next_state == TRANSITION) && (current_state == STABLE_0);
            down <= (next_state == TRANSITION) && (current_state == STABLE_1);
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            STABLE_0: begin
                next_state = a ? TRANSITION : STABLE_0;
            end
            
            STABLE_1: begin
                next_state = a ? STABLE_1 : TRANSITION;
            end
            
            TRANSITION: begin
                // After transition, move to new stable state
                next_state = a ? STABLE_1 : STABLE_0;
            end
            
            default: next_state = STABLE_0;
        endcase
    end

endmodule
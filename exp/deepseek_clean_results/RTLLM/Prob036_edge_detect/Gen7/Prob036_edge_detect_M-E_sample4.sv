module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    typedef enum logic [1:0] {
        LOW_STATE,
        HIGH_STATE,
        RISE_EDGE,
        FALL_EDGE
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= LOW_STATE;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            current_state <= next_state;
            // Default outputs
            rise <= 1'b0;
            down <= 1'b0;
            
            // Set outputs during edge states
            case (next_state)
                RISE_EDGE: rise <= 1'b1;
                FALL_EDGE: down <= 1'b1;
                default: begin
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            endcase
        end
    end

    always_comb begin
        case (current_state)
            LOW_STATE:
                next_state = a ? RISE_EDGE : LOW_STATE;
            HIGH_STATE:
                next_state = a ? HIGH_STATE : FALL_EDGE;
            RISE_EDGE:
                next_state = HIGH_STATE;
            FALL_EDGE:
                next_state = LOW_STATE;
            default:
                next_state = LOW_STATE;
        endcase
    end

endmodule
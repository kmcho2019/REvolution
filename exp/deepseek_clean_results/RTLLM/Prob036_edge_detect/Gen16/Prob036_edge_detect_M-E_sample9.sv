module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    // Synchronizer flip-flops for metastability protection
    reg a_sync, a_meta;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_meta <= 1'b0;
            a_sync <= 1'b0;
        end else begin
            a_meta <= a;
            a_sync <= a_meta;
        end
    end

    // Edge detection state machine
    typedef enum logic [1:0] {
        IDLE,
        RISING,
        FALLING
    } state_t;

    state_t state, next_state;
    reg a_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            a_prev <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            state <= next_state;
            a_prev <= a_sync;
            
            // Default outputs
            rise <= 1'b0;
            down <= 1'b0;
            
            // Set outputs based on state
            case (state)
                RISING:  rise <= 1'b1;
                FALLING: down <= 1'b1;
                default: begin
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (a_prev && !a_sync) next_state = FALLING;
                else if (!a_prev && a_sync) next_state = RISING;
            end
            RISING, FALLING: next_state = IDLE;
        endcase
    end

endmodule
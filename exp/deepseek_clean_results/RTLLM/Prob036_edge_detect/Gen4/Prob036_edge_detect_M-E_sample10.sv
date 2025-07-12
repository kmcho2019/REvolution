module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    // State encoding
    typedef enum logic [1:0] {
        STABLE_0,
        RISING,
        STABLE_1,
        FALLING
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            STABLE_0: next_state = a ? RISING : STABLE_0;
            RISING:  next_state = a ? STABLE_1 : FALLING;
            STABLE_1: next_state = a ? STABLE_1 : FALLING;
            FALLING: next_state = a ? RISING : STABLE_0;
            default:  next_state = STABLE_0;
        endcase
    end

    // Output logic
    always @(*) begin
        rise = (current_state == RISING);
        down = (current_state == FALLING);
    end

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= STABLE_0;
        end else begin
            current_state <= next_state;
        end
    end

endmodule
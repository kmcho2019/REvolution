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
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= STABLE_0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (current_state)
            STABLE_0: begin
                rise = 1'b0;
                down = 1'b0;
                next_state = a ? RISING : STABLE_0;
            end
            RISING: begin
                rise = 1'b1;
                down = 1'b0;
                next_state = a ? STABLE_1 : FALLING;
            end
            STABLE_1: begin
                rise = 1'b0;
                down = 1'b0;
                next_state = a ? STABLE_1 : FALLING;
            end
            FALLING: begin
                rise = 1'b0;
                down = 1'b1;
                next_state = a ? RISING : STABLE_0;
            end
            default: begin
                rise = 1'b0;
                down = 1'b0;
                next_state = STABLE_0;
            end
        endcase
    end

endmodule
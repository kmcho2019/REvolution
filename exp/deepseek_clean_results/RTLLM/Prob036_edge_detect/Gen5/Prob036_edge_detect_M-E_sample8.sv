module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        RISING  = 2'b01,
        FALLING = 2'b10
    } state_t;

    state_t current_state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        rise = 1'b0;
        down = 1'b0;

        case (current_state)
            IDLE: begin
                if (a && !rise) begin
                    next_state = RISING;
                end
                else if (!a && !down) begin
                    next_state = FALLING;
                end
            end
            RISING: begin
                rise = 1'b1;
                next_state = IDLE;
            end
            FALLING: begin
                down = 1'b1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
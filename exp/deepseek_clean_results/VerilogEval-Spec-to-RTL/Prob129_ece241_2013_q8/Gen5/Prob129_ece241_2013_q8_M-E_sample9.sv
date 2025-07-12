module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE,
        GOT1,
        GOT10
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                z = 0;
                next_state = x ? GOT1 : IDLE;
            end
            GOT1: begin
                z = 0;
                next_state = x ? GOT1 : GOT10;
            end
            GOT10: begin
                z = x;
                next_state = x ? GOT1 : IDLE;
            end
            default: begin
                z = 0;
                next_state = IDLE;
            end
        endcase
    end

endmodule
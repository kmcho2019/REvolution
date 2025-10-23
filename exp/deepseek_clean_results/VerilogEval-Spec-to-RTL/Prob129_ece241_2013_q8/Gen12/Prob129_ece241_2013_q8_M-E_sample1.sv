module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    typedef enum {IDLE, GOT1, GOT10} state_t;
    state_t current_state, next_state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: next_state = x ? GOT1 : IDLE;
            GOT1: next_state = x ? GOT1 : GOT10;
            GOT10: next_state = x ? GOT1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        z = (current_state == GOT10) && x;
    end

endmodule
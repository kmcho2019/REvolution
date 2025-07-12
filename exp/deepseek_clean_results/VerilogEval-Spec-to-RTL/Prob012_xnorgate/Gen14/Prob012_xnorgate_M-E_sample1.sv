module TopModule (
    input a,
    input b,
    output reg out
);
    // Define states
    typedef enum {STATE0, STATE1} state_t;
    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            STATE0: next_state = (a ^ b) ? STATE1 : STATE0;
            STATE1: next_state = (a ^ b) ? STATE1 : STATE0;
        endcase
    end

    // Output logic
    always @(*) begin
        out = (current_state == STATE0) ? 1'b1 : 1'b0;
    end

    // State register (initialized to STATE0)
    always @(posedge a or posedge b) begin
        current_state <= next_state;
    end

    initial begin
        current_state = STATE0;
    end
endmodule
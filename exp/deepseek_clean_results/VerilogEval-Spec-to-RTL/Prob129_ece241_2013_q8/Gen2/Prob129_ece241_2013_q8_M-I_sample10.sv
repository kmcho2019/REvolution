module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        GOT1,
        GOT10
    } state_t;

    // State registers
    state_t current_state, next_state;

    // State transition and output registers
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= IDLE;
            z <= 0;
        end else begin
            current_state <= next_state;
            // Mealy output registered to prevent glitches
            z <= (current_state == GOT10) & x;
        end
    end

    // Next state logic with default assignments
    always @(*) begin
        // Default assignments
        next_state = current_state;
        
        case (current_state)
            IDLE:   if (x) next_state = GOT1;
            GOT1:   if (!x) next_state = GOT10;
            GOT10:  next_state = x ? GOT1 : IDLE;
        endcase
    end

endmodule
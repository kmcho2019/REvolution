module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Define states
    typedef enum logic [1:0] {
        S0 = 2'b00,  // Initial state
        S1 = 2'b01,  // Got '1'
        S2 = 2'b10   // Got '10'
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic (Mealy)
    always @(*) begin
        case (current_state)
            S0: begin
                z = 1'b0;
                next_state = x ? S1 : S0;
            end
            S1: begin
                z = 1'b0;
                next_state = x ? S1 : S2;
            end
            S2: begin
                z = x ? 1'b1 : 1'b0;
                next_state = x ? S1 : S0;
            end
            default: begin
                z = 1'b0;
                next_state = S0;
            end
        endcase
    end

endmodule
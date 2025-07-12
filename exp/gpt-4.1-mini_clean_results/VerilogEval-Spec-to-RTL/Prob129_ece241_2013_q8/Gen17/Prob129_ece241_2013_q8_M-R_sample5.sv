module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding using parameters
    parameter S_IDLE = 2'd0;
    parameter S_1    = 2'd1;
    parameter S_10   = 2'd2;

    reg [1:0] state, next_state;

    // Combine next state logic and state update in one always block with async reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S_IDLE;
            z <= 1'b0;
        end else begin
            // Next state logic
            case (state)
                S_IDLE:  next_state = x ? S_1 : S_IDLE;
                S_1:     next_state = x ? S_1 : S_10;
                S_10:    next_state = x ? S_1 : S_IDLE;
                default: next_state = S_IDLE;
            endcase

            // Update state
            state <= next_state;

            // Mealy output logic: asserted when current state is S_10 and input x=1
            z <= (state == S_10) && x;
        end
    end

endmodule
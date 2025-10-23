module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);
    typedef enum reg [1:0] {A=2'b00, B=2'b01, C=2'b10, D=2'b11} state_t;
    state_t state, next_state;

    // Function to get output based on current state (Moore output)
    function automatic bit state_output(state_t s);
        begin
            state_output = (s == D);
        end
    endfunction

    // Sequential logic for state and next state
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            case (state)
                A: next_state <= (in == 1'b0) ? A : B;
                B: next_state <= (in == 1'b0) ? C : B;
                C: next_state <= (in == 1'b0) ? A : D;
                D: next_state <= (in == 1'b0) ? C : B;
                default: next_state <= A;
            endcase

            state <= next_state;
            out <= state_output(next_state);
        end
    end

endmodule
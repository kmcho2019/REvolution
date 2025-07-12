module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // Define states with enum type style
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Function to calculate next state from current state and input
    function state_t get_next_state(input state_t state, input logic in_sig);
        begin
            case (state)
                A: get_next_state = (in_sig == 1'b0) ? A : B;
                B: get_next_state = (in_sig == 1'b0) ? C : B;
                C: get_next_state = (in_sig == 1'b0) ? A : D;
                D: get_next_state = (in_sig == 1'b0) ? C : B;
                default: get_next_state = A;
            endcase
        end
    endfunction

    // Sequential state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Combinational next state logic using the function
    always @(*) begin
        next_state = get_next_state(current_state, in);
    end

    // Moore output registered synchronously from current state
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;
        else
            out <= (current_state == D);
    end

endmodule
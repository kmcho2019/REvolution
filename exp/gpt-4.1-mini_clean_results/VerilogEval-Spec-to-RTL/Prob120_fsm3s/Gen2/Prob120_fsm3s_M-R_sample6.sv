module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t state, next_state;

    // Function to determine next state
    function state_t get_next_state(state_t curr, input logic in_sig);
        begin
            case(curr)
                A: get_next_state = in_sig ? B : A;
                B: get_next_state = in_sig ? B : C;
                C: get_next_state = in_sig ? D : A;
                D: get_next_state = in_sig ? B : C;
                default: get_next_state = A;
            endcase
        end
    endfunction

    // State register with synchronous active high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Compute next state
    always @(*) begin
        next_state = get_next_state(state, in);
    end

    // Moore output combinationally assigned based on current state
    assign out = (state == D);

endmodule
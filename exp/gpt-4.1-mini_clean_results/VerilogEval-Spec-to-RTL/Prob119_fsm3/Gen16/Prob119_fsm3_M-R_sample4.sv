module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // Enumerated state type
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t state, next_state;

    // Sequential state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Function to compute next state
    function automatic state_t calc_next_state(state_t cur_state, input in_signal);
        case (cur_state)
            A: calc_next_state = in_signal ? B : A;
            B: calc_next_state = in_signal ? B : C;
            C: calc_next_state = in_signal ? D : A;
            D: calc_next_state = in_signal ? B : C;
            default: calc_next_state = A;
        endcase
    endfunction

    // Next state combinational assignment
    assign next_state = calc_next_state(state, in);

    // Moore output depends only on state D
    assign out = (state == D) ? 1'b1 : 1'b0;

endmodule
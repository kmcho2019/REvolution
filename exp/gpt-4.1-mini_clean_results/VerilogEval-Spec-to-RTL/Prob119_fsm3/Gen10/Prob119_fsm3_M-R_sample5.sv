module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    typedef enum logic [1:0] {A=2'b00, B=2'b01, C=2'b10, D=2'b11} state_t;
    state_t state, next_state;

    // Next state logic encapsulated in a function
    function state_t get_next_state(state_t current, logic input_signal);
        case (current)
            A: get_next_state = input_signal ? B : A;
            B: get_next_state = input_signal ? B : C;
            C: get_next_state = input_signal ? D : A;
            D: get_next_state = input_signal ? B : C;
            default: get_next_state = A;
        endcase
    endfunction

    // Sequential logic: state register and output register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= get_next_state(state, in);
            out <= (state == D);
        end
    end

endmodule
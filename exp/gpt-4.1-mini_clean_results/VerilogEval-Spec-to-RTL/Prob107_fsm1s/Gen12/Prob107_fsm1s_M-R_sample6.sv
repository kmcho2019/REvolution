module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding as enumerated type
    typedef enum logic { B = 1'b0, A = 1'b1 } state_t;
    state_t state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Synchronous state register update with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output based on current state
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule
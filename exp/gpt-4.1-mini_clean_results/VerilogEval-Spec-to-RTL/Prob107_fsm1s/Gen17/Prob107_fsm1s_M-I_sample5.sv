module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0, A = 1'b1;

    reg state;
    reg next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // safe default
        endcase
    end

    // State register with synchronous active-high reset and conditional update to reduce toggling
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else if (next_state != state)
            state <= next_state;
    end

    // Output logic for Moore FSM
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule
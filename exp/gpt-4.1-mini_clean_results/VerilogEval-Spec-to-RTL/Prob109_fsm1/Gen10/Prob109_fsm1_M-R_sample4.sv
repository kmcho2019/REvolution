module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Combinational logic for next state
    always @(*) begin
        case(state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B; // default to B for safety
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output reflects current state (Moore machine)
    assign out = state;

endmodule
module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Combinational logic for next state using a simple Boolean expression
    always @(*) begin
        // next_state = (state == B) ? (in ? B : A) : (in ? A : B);
        // Equivalent to:
        // If state == B and in==0 -> A
        // If state == B and in==1 -> B
        // If state == A and in==0 -> B
        // If state == A and in==1 -> A
        if (state == B)
            next_state = in ? B : A;
        else // state == A
            next_state = in ? A : B;
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output directly from registered state
    assign out = state;

endmodule
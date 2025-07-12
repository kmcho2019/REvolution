module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B;
        endcase
    end

    // Sequential logic: State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output reflects the current registered state directly
    assign out = state;

endmodule
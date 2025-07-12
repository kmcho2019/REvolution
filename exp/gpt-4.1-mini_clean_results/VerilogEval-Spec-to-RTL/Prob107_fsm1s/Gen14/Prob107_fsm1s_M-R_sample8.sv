module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;
    reg next_state;

    // Combinational logic for next state
    always @(*) begin
        case (state)
            B: next_state = (in == 0) ? A : B;
            A: next_state = (in == 0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Sequential logic for state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output depends only on current state
    assign out = (state == B);

endmodule
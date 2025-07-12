module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // State register with synchronous reset and next state logic
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Output logic (Moore output depends only on state)
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule
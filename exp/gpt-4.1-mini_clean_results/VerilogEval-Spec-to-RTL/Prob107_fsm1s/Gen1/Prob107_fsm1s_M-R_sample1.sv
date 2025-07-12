module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    parameter B = 1'b0;
    parameter A = 1'b1;

    reg state, next_state;

    // State transition sequential logic
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Moore output: out = 1 when in state B, else 0
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule
module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // State register with synchronous active-high reset
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

    // Output logic (Moore output depends on current state)
    always @(*) begin
        case (state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b1;
        endcase
    end

endmodule
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding using localparam
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // Next state combinational logic with explicit default
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // State register update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output: assigned combinationally based on current state
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule
module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state combinational logic with case statement for clarity
    always @(*) begin
        case(state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // safe default
        endcase
    end

    // Moore output assigned directly and continuously from current state
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule
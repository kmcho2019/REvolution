module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding (2-bit binary)
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    reg [1:0] state, next_state;

    // Sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next-state logic derived directly from the table
    // next_state[1] and next_state[0] are assigned from state and input 'in'
    always @(*) begin
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A;
        endcase
    end

    // Moore output: output is 1 only in state D
    assign out = (state == D);

endmodule
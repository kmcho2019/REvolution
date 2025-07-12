module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding using localparams for clarity and synthesis friendliness
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state, next_state;

    // Sequential state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state logic using case statement for clarity and easy mapping to transitions
    always @(*) begin
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A;  // Safe default
        endcase
    end

    // Moore output: high only in state D, simple continuous assignment for minimal logic and timing
    assign out = (state == D);

endmodule
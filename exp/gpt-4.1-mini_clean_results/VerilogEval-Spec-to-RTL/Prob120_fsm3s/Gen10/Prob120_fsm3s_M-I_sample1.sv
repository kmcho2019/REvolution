module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state, next_state;

    // Next-state combinational logic using case statement for better synthesis
    always @(*) begin
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A; // Defensive default
        endcase
    end

    // Sequential state register with synchronous active high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output: asserted only in state D
    assign out = (state == D);

endmodule
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Gray code state encoding for minimal transitions
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter D = 2'b11;
    parameter C = 2'b10;

    reg [1:0] state;

    // Next state logic with case statement
    always @(*) begin
        case (state)
            A: state = in ? B : A;
            B: state = in ? B : C;
            C: state = in ? D : A;
            D: state = in ? B : C;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Direct state comparison for output (only high in state D)
    assign out = (state == D);

endmodule
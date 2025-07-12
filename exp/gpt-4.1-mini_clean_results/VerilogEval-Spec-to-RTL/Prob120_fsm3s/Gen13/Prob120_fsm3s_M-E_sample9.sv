module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // One-hot encoding of states (4 states)
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Sequential: state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational: next state logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;  // Safe default
        endcase
    end

    // Output logic: Moore output depends only on current state D
    always @(*) begin
        out = (state == D);
    end

endmodule
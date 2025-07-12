module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding: A=0, B=1
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            B: next_state = (~in) ? A : B;
            A: next_state = (~in) ? B : A;
            default: next_state = B; // safe default to reset state
        endcase
    end

    // Sequential state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore machine output depends only on state
    assign out = (state == B);

endmodule
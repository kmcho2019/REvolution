module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // One-hot state encoding for better PPA trade-offs
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Synchronous output register (Moore output depends only on state)
    always @(posedge clk) begin
        if (reset)
            out <= 1'b0;
        else
            out <= (state == D) ? 1'b1 : 1'b0;
    end

endmodule
module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            B: next_state = in ? B : A;  // B with output 1
            A: next_state = in ? A : B;  // A with output 0
            default: next_state = B;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output register
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1;  // output of B state
        else
            out <= (state == B) ? 1'b1 : 1'b0;
    end

endmodule
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;
    wire next_state;

    // Next state logic as combinational expression
    assign next_state = (state == B) ? (in ? B : A) : (in ? A : B);

    // Synchronous state update with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Output logic: Moore output depends solely on state
    assign out = (state == B);

endmodule
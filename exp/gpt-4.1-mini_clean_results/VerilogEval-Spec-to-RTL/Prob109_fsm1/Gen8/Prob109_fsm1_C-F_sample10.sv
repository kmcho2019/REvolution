module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;        // 0 = A, 1 = B
    wire next_state;

    // Next state logic: B(1) on '1', A(0) on '0'; transitions based on input 'in'
    // next_state = state XOR (NOT in)
    assign next_state = state ^ ~in;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // Asynchronously reset to state B
        else
            state <= next_state;
    end

    assign out = state;

endmodule
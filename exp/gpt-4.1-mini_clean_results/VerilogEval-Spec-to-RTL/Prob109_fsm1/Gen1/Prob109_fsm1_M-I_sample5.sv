module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;  // Reset state to B
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        if (state == B)
            next_state = (in == 1'b0) ? A : B;
        else // state == A
            next_state = (in == 1'b0) ? B : A;
    end

    // Moore output logic: output = state bit directly
    assign out = state;

endmodule
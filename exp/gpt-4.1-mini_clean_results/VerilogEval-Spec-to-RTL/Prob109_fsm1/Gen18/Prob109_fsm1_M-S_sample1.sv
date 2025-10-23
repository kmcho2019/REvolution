module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // State register with asynchronous reset and next state logic combined
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else if (state == B)
            state <= in ? B : A;
        else // state == A
            state <= in ? A : B;
    end

    // Moore output directly assigned from state register
    assign out = state;

endmodule
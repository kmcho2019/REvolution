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

    // State register with asynchronous reset and direct next state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;  // Reset state to B
        else
            state <= (state == B) ? (in ? B : A) : (in ? A : B);
    end

    // Moore output based on current state
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule
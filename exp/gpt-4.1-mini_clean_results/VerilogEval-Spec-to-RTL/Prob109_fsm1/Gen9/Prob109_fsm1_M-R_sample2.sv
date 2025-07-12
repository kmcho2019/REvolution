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

    // Combinational next state logic as continuous assignment
    wire next_state = (state == B) ? (in ? B : A) : (in ? A : B);

    // Sequential state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output driven directly from state
    assign out = state;

endmodule
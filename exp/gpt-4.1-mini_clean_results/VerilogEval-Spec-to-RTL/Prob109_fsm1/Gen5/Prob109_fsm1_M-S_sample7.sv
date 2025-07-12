module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;         // state B
        else
            state <= state ^ ~in;  // toggle state if in==0
    end

    assign out = state;

endmodule
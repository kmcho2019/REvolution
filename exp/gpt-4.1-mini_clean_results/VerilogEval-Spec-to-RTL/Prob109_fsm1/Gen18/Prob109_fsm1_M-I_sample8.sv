module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state; // 0 = A, 1 = B

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // reset to B
        else
            state <= ~(state ^ in); // XNOR instead of XOR with inverted in
    end

    assign out = state;

endmodule
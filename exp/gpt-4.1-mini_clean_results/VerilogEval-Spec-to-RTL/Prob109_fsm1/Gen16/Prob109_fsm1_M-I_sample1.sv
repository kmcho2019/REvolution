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

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;  // reset to B
        else
            state <= (state == B) ? (in ? B : A)
                                  : (in ? A : B);
    end

    assign out = state;

endmodule
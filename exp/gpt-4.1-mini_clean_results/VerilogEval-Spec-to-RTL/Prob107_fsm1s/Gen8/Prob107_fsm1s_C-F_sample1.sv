module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= B;  // synchronous active-high reset to B
        else
            state <= (state == B) ? (in ? B : A)
                                  : (in ? A : B);
    end

    // Moore output: out=1 in B, 0 in A
    assign out = (state == B);

endmodule
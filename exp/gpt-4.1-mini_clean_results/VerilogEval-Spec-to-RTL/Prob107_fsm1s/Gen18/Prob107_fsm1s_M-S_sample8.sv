module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0, A = 1'b1;
    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= B;
        else if (state == B)
            state <= (in == 1'b0) ? A : B;
        else
            state <= (in == 1'b0) ? B : A;
    end

    assign out = (state == B);

endmodule
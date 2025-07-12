module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    localparam B = 1'b0, A = 1'b1;
    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= B;
        else if (state == B)
            state <= in ? B : A;
        else
            state <= in ? A : B;
    end

    assign out = (state == B);

endmodule
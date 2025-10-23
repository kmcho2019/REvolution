module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else if (state == B)
            state <= in ? B : A;
        else
            state <= in ? A : B;
    end

    assign out = state;

endmodule
module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    parameter A = 1'b0, B = 1'b1;
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= in ? state : (state == A ? B : A);
    end

    assign out = state;

endmodule
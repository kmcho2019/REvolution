module TopModule (
    input  [5:0] y,
    input        w,
    output       Y2,
    output       Y4
);

    reg Y2_r, Y4_r;

    always @(*) begin
        // Default outputs
        Y2_r = 1'b0;
        Y4_r = 1'b0;

        // Y2: next state bit for y[1] (B) active if current state A (y[0]) and w=0
        if (y[0] && ~w)
            Y2_r = 1'b1;

        // Y4: next state bit for y[3] (D) active if w=1 and current state in B(1), C(2), E(4), F(5)
        if (w && (y[1] | y[2] | y[4] | y[5]))
            Y4_r = 1'b1;
    end

    assign Y2 = Y2_r;
    assign Y4 = Y4_r;

endmodule
module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    // On posedge clk:
    //  - Load R into Q if L asserted and differs from current Q
    //  - Else shift in w if E asserted and differs from current Q
    //  - Else retain Q
    always @(posedge clk) begin
        if (L) begin
            if (Q != R)
                Q <= R;
        end else if (E) begin
            if (Q != w)
                Q <= w;
        end
        // else retain Q implicitly
    end

endmodule
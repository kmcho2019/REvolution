module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    // On posedge clk, load R into Q if L asserted;
    // else if E asserted, shift in w; else retain previous Q.
    always @(posedge clk) begin
        if (L)
            Q <= R;
        else if (E)
            Q <= w;
        // else Q holds its value implicitly
    end

endmodule
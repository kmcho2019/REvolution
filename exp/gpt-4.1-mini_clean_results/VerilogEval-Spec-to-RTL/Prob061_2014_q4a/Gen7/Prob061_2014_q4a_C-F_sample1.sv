module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    always @(posedge clk) begin
        if (L)
            Q <= R;
        else if (E)
            Q <= w;
        // no assignment if neither L nor E asserted, Q retains its value
    end

endmodule
module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    wire nextQ = L ? R : w;

    always @(posedge clk) begin
        if (L || E)
            Q <= nextQ;
    end

endmodule
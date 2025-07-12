module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    wire clk_en = L | E;
    wire next_Q = L ? R : w;

    always @(posedge clk) begin
        if (clk_en)
            Q <= next_Q;
    end

endmodule
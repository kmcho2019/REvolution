module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    wire next_Q;
    wire clk_en;

    assign clk_en = L | E;
    assign next_Q = L ? R : (E ? w : Q);

    always @(posedge clk) begin
        if (clk_en)
            Q <= next_Q;
    end

endmodule
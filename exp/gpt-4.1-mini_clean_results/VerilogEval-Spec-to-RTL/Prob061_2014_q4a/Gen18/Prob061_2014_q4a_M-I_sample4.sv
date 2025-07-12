module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    wire clk_en = L | E;
    wire data_in = L ? R : w;

    always @(posedge clk) begin
        if (clk_en)
            Q <= data_in;
    end

endmodule
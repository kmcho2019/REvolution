module TopModule (
    input clk,
    input d,
    output reg q
);

    wire clk_edge;
    reg clk_prev;

    // Edge detection
    assign clk_edge = clk ^ clk_prev;

    always @(*) begin
        if (clk_edge) begin
            q = d;
        end
    end

    always @(*) begin
        clk_prev = clk;
    end

endmodule
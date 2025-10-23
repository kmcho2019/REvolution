module TopModule (
    input clk,
    input d,
    output reg q
);

    reg last_clk;
    wire clk_edge = clk ^ last_clk;
    reg enable;

    always @(posedge clk) begin
        last_clk <= 1'b1;
        if (clk_edge) enable <= ~enable;
    end

    always @(negedge clk) begin
        last_clk <= 1'b0;
    end

    always @(posedge enable) begin
        q <= d;
    end

endmodule
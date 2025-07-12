module TopModule (
    input        clk,
    input  [7:0] d,
    output reg [7:0] q
);

    wire clk_en;
    reg [7:0] d_reg;

    // Detect if input 'd' differs from current output 'q'
    assign clk_en = (d != q);

    // Gated clock using clk_en
    wire gated_clk = clk & clk_en;

    always @(posedge clk) begin
        if (clk_en) begin
            q <= d;
        end
    end

endmodule
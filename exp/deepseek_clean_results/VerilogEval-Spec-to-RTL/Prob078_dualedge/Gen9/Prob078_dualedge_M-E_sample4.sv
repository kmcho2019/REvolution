module TopModule (
    input clk,
    input d,
    output reg q
);

    reg prev_clk;
    wire clk_edge;

    // Edge detection
    assign clk_edge = clk ^ prev_clk;

    always @(posedge clk_edge) begin
        q <= d;
    end

    always @(posedge clk or negedge clk) begin
        prev_clk <= clk;
    end

endmodule
module clkgenerator #(
    parameter integer PERIOD = 10
) (
    input  wire clk_in,
    output reg  clk
);

    localparam integer HALF_PERIOD = PERIOD / 2;

    integer count;

    initial begin
        clk = 1'b0;
        count = 0;
    end

    always @(posedge clk_in) begin
        if (count == HALF_PERIOD - 1) begin
            clk <= ~clk;
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
endmodule
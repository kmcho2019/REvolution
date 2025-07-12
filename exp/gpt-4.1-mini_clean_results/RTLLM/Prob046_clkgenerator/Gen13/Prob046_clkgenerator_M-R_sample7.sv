module clkgenerator #(
    parameter PERIOD = 10
) (
    input  wire clk_in,
    output reg  clk
);

    // Width of counter to count up to half PERIOD
    localparam COUNT_MAX = (PERIOD >> 1) - 1;
    // Support minimum PERIOD of 2
    // Counter width
    localparam WIDTH = (PERIOD > 2) ? $clog2(COUNT_MAX+1) : 1;

    reg [WIDTH-1:0] count;

    initial begin
        clk = 0;
        count = 0;
    end

    always @(posedge clk_in) begin
        if (count == COUNT_MAX) begin
            count <= 0;
            clk <= ~clk;
        end else begin
            count <= count + 1;
        end
    end

endmodule
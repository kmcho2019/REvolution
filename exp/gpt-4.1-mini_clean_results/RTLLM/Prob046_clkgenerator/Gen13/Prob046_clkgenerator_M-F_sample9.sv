module clkgenerator #(
    parameter PERIOD = 10
) (
    input  wire clk_in,   // input reference clock
    input  wire reset,    // synchronous reset, active high
    output reg  clk       // output generated clock
);

    // Calculate counter width based on PERIOD
    localparam WIDTH = $clog2(PERIOD/2);

    reg [WIDTH-1:0] count;

    always @(posedge clk_in) begin
        if (reset) begin
            count <= 0;
            clk   <= 0;
        end else begin
            if (count == (PERIOD/2 - 1)) begin
                count <= 0;
                clk   <= ~clk;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule
module clkgenerator #(
    parameter PERIOD = 10
)(
    input  sys_clk,
    input  rst,
    output reg clk
);

reg [$clog2(PERIOD):0] counter = 0;
localparam half_period = PERIOD / 2;

always @(posedge sys_clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        clk <= 0;
    end else begin
        counter <= counter + 1;
        if (counter == half_period) begin
            counter <= 0;
            clk <= ~clk;
        end
    end
end

endmodule
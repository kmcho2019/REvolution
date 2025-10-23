module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [$clog2(PERIOD):0] counter = 0;
localparam half_period = PERIOD / 2;

always @(posedge clk or negedge clk) begin
    if (counter == half_period) begin
        counter <= 0;
        clk <= ~clk;
    end else begin
        counter <= counter + 1;
    end
end

initial begin
    clk = 0;
end

endmodule
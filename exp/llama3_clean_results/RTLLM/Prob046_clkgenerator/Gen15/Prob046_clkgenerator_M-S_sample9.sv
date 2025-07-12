module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [$clog2(PERIOD):0] counter = 0;

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == (PERIOD / 2)) begin
        counter <= 0;
        clk <= ~clk;
    end
end

initial begin
    clk = 0;
end

endmodule
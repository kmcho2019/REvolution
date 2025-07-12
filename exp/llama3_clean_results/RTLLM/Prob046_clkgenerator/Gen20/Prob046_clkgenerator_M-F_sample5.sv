module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter;
reg [31:0] half_period;

initial begin
    counter = 0;
    half_period = PERIOD / 2;
    if (PERIOD % 2 != 0) begin
        half_period = (PERIOD / 2) + 1;
    end
    clk = 1'b0;
end

always @(posedge $global_clock) begin
    if (counter == half_period) begin
        clk = ~clk;
        counter = 0;
    end else begin
        counter = counter + 1;
    end
end

endmodule
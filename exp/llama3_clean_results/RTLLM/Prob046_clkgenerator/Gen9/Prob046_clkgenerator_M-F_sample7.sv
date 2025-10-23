module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter;
reg prev_clk;

initial begin
    counter = 0;
    prev_clk = 0;
    clk = 0;
end

always @(posedge clk) begin
    counter = counter + 1;
    if (counter >= (PERIOD / 2)) begin
        counter = 0;
        prev_clk = ~prev_clk;
        clk = prev_clk;
    end
end

always @(negedge prev_clk) begin
    #((PERIOD / 2));
    prev_clk = ~prev_clk;
    clk = prev_clk;
end

endmodule
module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter;

initial begin
    counter = 0;
    clk = 0;
end

always @(posedge $root.clk) begin
    counter = counter + 1;
    if (counter == (PERIOD / 2)) begin
        counter = 0;
        clk = ~clk;
    end
end

endmodule
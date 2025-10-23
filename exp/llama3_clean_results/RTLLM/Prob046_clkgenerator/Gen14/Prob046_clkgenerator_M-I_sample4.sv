module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [3:0] counter = 0;

initial begin
    clk = 0;
end

always @(*) begin
    if (counter == (PERIOD / 2)) begin
        counter = 0;
        clk = ~clk;
    end else begin
        counter = counter + 1;
    end
end

endmodule
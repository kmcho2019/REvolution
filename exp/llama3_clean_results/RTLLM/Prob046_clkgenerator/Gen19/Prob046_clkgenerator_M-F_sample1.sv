module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter;

initial begin
    counter = 0;
    clk = 1'b0;
end

always @(counter) begin
    if (counter == (PERIOD / 2)) begin
        clk = ~clk;
        counter = 0;
    end else begin
        counter = counter + 1;
    end
end

endmodule
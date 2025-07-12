module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always @(*) begin
    if (counter < (PERIOD / 2)) begin
        clk = 1'b0;
    end else if (counter < PERIOD) begin
        clk = 1'b1;
    end else begin
        clk = 1'b0;
        counter = 0;
    end
    counter = counter + 1;
end

endmodule
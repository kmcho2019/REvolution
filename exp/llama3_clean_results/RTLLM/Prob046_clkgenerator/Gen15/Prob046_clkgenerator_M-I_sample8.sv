module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always @(counter) begin
    if (counter == (PERIOD / 2)) begin
        counter <= 0;
        clk <= ~clk;
    end else begin
        counter <= counter + 1;
    end
end

initial begin
    counter = 0;
    clk = 0;
end

endmodule
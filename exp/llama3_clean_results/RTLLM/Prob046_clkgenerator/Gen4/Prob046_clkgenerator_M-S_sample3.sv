module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always @(posedge clk) begin
    if (counter == (PERIOD / 2 - 1)) begin
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

initial begin
    clk = 0;
    #1;
    forever #1 clk = ~clk;
end

endmodule
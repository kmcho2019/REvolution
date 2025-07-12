module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always @(counter) begin
    if (counter == (PERIOD / 2)) begin
        clk = ~clk;
        counter = 0;
    end else begin
        counter = counter + 1;
    end
end

initial begin
    clk = 0;
    forever begin
        #1;
    end
end

endmodule
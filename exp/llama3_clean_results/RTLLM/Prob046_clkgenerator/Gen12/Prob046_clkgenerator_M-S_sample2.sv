module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always @(posedge $global_clock) begin
    counter <= counter + 1;
    if (counter == (PERIOD / 2 - 1)) begin
        counter <= 0;
        clk <= ~clk;
    end
end

initial begin
    counter = 0;
    clk = 0;
end

endmodule
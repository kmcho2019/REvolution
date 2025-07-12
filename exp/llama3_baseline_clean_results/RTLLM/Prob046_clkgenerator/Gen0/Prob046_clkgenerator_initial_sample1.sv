module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

integer counter = 0;

initial begin
    clk = 0;
end

always @(posedge $global_clock) begin
    counter = counter + 1;
    if (counter == (PERIOD / 2)) begin
        clk = ~clk;
        counter = 0;
    end
end

endmodule
module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

integer counter = 0;

always @(posedge $global_clock) begin
    counter = counter + 1;
    if (counter == (PERIOD / 2)) begin
        counter = 0;
        clk = ~clk;
    end
end

initial begin
    clk = 0;
end

endmodule
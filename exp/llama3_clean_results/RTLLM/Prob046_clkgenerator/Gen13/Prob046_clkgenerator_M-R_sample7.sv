module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter;

always @(posedge $global_clock) begin
    if (counter >= (PERIOD / 2)) begin
        clk = ~clk;
        counter = 0;
    end else begin
        counter = counter + 1;
    end
end

initial begin
    counter = 0;
    clk = 0;
end

endmodule
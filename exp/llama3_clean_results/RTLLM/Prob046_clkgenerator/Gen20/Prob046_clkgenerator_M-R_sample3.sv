module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter;
initial begin
    counter = 0;
    clk = 0;
end

always @(counter) begin
    if (counter == (PERIOD / 2)) begin
        counter <= 0;
        clk <= !clk;
    end else begin
        counter <= counter + 1;
    end
end

always #1 begin
    // do nothing, just to advance the simulation time
end

endmodule
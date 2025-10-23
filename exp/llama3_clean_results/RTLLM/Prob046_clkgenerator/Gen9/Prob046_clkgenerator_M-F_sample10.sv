module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

initial begin
    clk = 0;
end

always @(posedge $global_clock) begin // Assuming $global_clock is the system clock
    if (counter < (PERIOD / 2) - 1) begin
        counter <= counter + 1;
    end else if (counter == (PERIOD / 2) - 1) begin
        clk <= ~clk;
        counter <= 0;
    end
end

endmodule
module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

integer counter = 0;

always #1 begin
    counter = counter + 1;
    if (counter == (PERIOD / 2)) begin
        counter = 0;
        clk = ~clk; // Toggle the clock signal
    end else if (counter == 0) begin
        clk = 0; // Ensure initial state is 0
    end
end

endmodule
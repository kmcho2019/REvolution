module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always @(posedge #1) begin // Simulate a default clock tick at every time unit
    counter <= counter + 1;
    
    if (counter == (PERIOD / 2 - 1)) begin
        clk <= ~clk;
        counter <= 0;
    end else if (counter == (PERIOD - 1)) begin
        counter <= 0;
    end
end

initial begin
    clk = 0;
end

endmodule
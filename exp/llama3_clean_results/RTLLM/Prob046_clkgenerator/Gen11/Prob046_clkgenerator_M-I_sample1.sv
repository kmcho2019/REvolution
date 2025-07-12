module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

localparam HALF_PERIOD = PERIOD / 2;
reg [HALF_PERIOD-1:0] counter; // Counter variable

initial begin
    clk = 0; // Initialize clock signal to 0
    counter = 0; // Initialize counter to 0
end

always @(posedge clk or negedge clk) begin // Using the output clock itself as it's the only signal we care about
    if (counter == HALF_PERIOD - 1) begin
        clk <= ~clk; // Toggle clock signal
        counter <= 0; // Reset counter
    end else begin
        counter <= counter + 1; // Increment counter
    end
end

endmodule
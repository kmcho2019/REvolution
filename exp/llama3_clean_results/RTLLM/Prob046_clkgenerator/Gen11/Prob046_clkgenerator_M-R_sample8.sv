module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [PERIOD-1:0] counter; // Counter variable

always @(posedge clk or negedge clk) begin
    if (~clk) begin // if clock is low, increment counter
        counter <= counter + 1;
    end else begin // if clock is high, check for period
        if (counter == PERIOD / 2 - 1) begin
            counter <= 0; // Reset counter
        end else begin
            counter <= counter + 1; // Increment counter
        end
    end
end

assign clk = (counter < PERIOD / 2) ? 0 : 1; // Generate clock signal

endmodule
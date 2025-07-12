module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter; // Counter to track the current time

always @(*) begin
    if (counter >= (PERIOD / 2)) begin
        clk = 1'b1; // Set clock high at half period
    end else begin
        clk = 1'b0; // Set clock low otherwise
    end
end

always @(posedge clk) begin
    if (counter >= PERIOD) begin
        counter <= 0; // Reset counter at the end of the period
    end else begin
        counter <= counter + 1; // Increment counter
    end
end

initial begin
    counter <= 0; // Initialize counter to 0
    clk <= 1'b0; // Initialize clock to 0
end

endmodule
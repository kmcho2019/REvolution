module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [7:0] counter; // Counter to track time
reg clk_int; // Internal clock signal

// Calculate half period, handling the case where PERIOD is odd
reg [7:0] half_period;
initial half_period = (PERIOD / 2);

always @(posedge counter[0] or negedge counter[0]) begin
    if (counter == half_period) begin
        clk_int = ~clk_int; // Toggle clock at half period
        counter = 0; // Reset counter
    end else begin
        counter = counter + 1; // Increment counter
    end
end

always @(*) begin
    if (counter <= half_period) begin
        clk = 1'b0; // Clock low during the first half of the period
    end else begin
        clk = 1'b1; // Clock high during the second half of the period
    end
end

initial begin
    counter = 0; // Initialize counter
    clk_int = 1'b0; // Initialize clock to 0
end

endmodule
module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] counter;

// Initialize the counter and output
initial counter = 4;
initial q = 4;

// Define the sequential logic
always @(posedge clk) begin
    if (a) begin
        counter <= 4; // Reset counter to 4 when a is high
    end else if (counter < 6) begin
        counter <= counter + 1; // Increment counter when a is low and counter < 6
    end else begin
        counter <= 0; // Wrap around to 0 when counter reaches 6
    end
end

// Assign output q to the counter value
assign q = counter;

endmodule
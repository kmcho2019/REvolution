module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize the output
initial q = 4;

// Define the counter and control logic
reg [2:0] counter;

always @(posedge clk) begin
    if (a) begin
        // Reset the counter to 4 when 'a' is high
        counter <= 4;
    end else begin
        // Conditionally increment or wrap around the counter when 'a' is low
        if (counter < 6) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
        end
    end
    
    // Assign the counter value to the output
    q <= counter;
end

endmodule
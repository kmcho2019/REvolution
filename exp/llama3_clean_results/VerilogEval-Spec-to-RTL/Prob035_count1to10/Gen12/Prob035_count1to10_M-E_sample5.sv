module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] counter; // 4-bit counter

// Asynchronous reset of the counter
initial begin
    counter = 4'b0001; // Initialize counter to 1 (since we're counting from 1 to 10)
end

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0001; // Reset counter to 1
    end else if (counter == 10) begin
        // If counter reaches 10, reset it to 1
        counter <= 4'b0001;
    end else begin
        // Increment counter
        counter <= counter + 1;
    end
end

// Directly assign counter value to output q
assign q = counter;

endmodule
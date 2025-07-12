module TopModule(
    input clk,
    input a,
    output reg q
);

reg [0:0] counter; // 1-bit counter

// Initialize counter to 0 and q to 1
initial begin
    counter = 1'b0;
    q = 1'b1;
end

// Update counter and q at the positive edge of the clock
always @(posedge clk) begin
    if (a) begin
        counter <= counter + 1'b1; // Increment counter
        q <= 1'b0; // Set q to 0
    end else if (counter!= 1'b0) begin
        counter <= 1'b0; // Reset counter
        q <= 1'b1; // Set q to 1
    end
end

endmodule
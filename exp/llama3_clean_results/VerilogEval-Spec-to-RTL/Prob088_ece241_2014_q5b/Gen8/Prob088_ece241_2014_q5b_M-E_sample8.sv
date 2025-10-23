module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] counter; // Counter to track sequence of x inputs
reg prev_x; // Previous value of x to detect transitions

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Asynchronous reset
        counter <= 2'b00;
        prev_x <= 1'b0;
    end else begin
        // Update previous x value
        prev_x <= x;
        
        // Update counter and output logic
        if (x && !prev_x) begin
            // Increment counter on rising edge of x
            counter <= counter + 1'b1;
        end
    end
end

// Generate output z based on counter state and x
always @(*) begin
    if (counter[0]) begin
        // If counter is odd, output z is the inverse of x
        z = ~x;
    end else begin
        // If counter is even, output z is x
        z = x;
    end
end

endmodule
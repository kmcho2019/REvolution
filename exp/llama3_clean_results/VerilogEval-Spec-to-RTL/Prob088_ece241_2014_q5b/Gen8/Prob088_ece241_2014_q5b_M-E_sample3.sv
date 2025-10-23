module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [0:0] counter; // Single-bit counter for state machine

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Reset counter to 0 (state A)
        counter <= 1'b0;
    end else begin
        // Increment counter if x=1 and current state is A
        if(counter == 1'b0 && x == 1'b1) begin
            counter <= 1'b1;
        end
    end
end

always @(*) begin
    // Generate output z based on counter value and input x
    if(counter == 1'b0) begin
        z = 1'b0; // State A, output z=0
    end else begin
        z = ~x; // State B, output z=x'
    end
end

endmodule
module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg counter; // Single-bit counter

always @(posedge clk) begin
    if(reset) begin
        counter <= 1'b0; // Reset counter to 0 (state B)
    end else begin
        // Update counter based on input
        if(in) begin
            // If input is 1, stay in current state or increment if in state B
            counter <= counter;
        end else begin
            // If input is 0, reset to state B
            counter <= 1'b0;
        end
    end
end

// Determine output based on counter value
assign out = ~counter;

endmodule
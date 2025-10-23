module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a 1-bit register to represent the state
reg out_reg; // Register for the output to minimize switching activity

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
        out_reg <= 1; // Output in reset state is 1
    end else begin
        state <= (state == 0)? ~in : in; // Simplified state transition logic
        out_reg <= ~state; // Update output register based on state
    end
end

assign out = out_reg; // Assign output from the registered output

endmodule
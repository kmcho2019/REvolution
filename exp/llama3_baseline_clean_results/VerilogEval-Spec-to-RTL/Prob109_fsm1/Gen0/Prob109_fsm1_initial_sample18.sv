module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg current_state; // Using a single bit to encode states A and B
assign out = current_state; // Output is the same as the current state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to state B
        current_state <= 1'b1;
    end else begin
        // Next state logic
        if (current_state == 1'b0) begin
            // Current state is A
            if (in == 1'b0) begin
                // Next state is B
                current_state <= 1'b1;
            end else begin
                // Next state is A
                current_state <= 1'b0;
            end
        end else begin
            // Current state is B
            if (in == 1'b0) begin
                // Next state is A
                current_state <= 1'b0;
            end else begin
                // Next state is B
                current_state <= 1'b1;
            end
        end
    end
end

endmodule
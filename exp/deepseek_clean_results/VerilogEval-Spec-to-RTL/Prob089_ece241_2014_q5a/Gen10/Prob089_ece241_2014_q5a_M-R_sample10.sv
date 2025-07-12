module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Single state bit: 0 = pass through, 1 = invert bits
    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            // State transition and output logic combined
            if (state) begin
                z <= ~x;  // Invert all bits after first '1'
            end else begin
                z <= x;    // Pass through until first '1'
                state <= x; // Transition to invert state on first '1'
            end
        end
    end

endmodule
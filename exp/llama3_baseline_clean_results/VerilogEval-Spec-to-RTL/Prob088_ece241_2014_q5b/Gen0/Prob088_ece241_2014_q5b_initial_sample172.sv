module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// One-hot encoding for states
reg [1:0] current_state;
reg [1:0] next_state;

// Define initial state (A) as 01 and use one-hot encoding
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 2'b01; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        2'b01: // State A
            begin
                if (x == 1'b0) begin
                    next_state = 2'b01; // Stay in A
                    z = 1'b0;
                end else begin
                    next_state = 2'b10; // Go to B
                    z = 1'b1;
                end
            end
        2'b10: // State B
            begin
                if (x == 1'b0) begin
                    next_state = 2'b10; // Stay in B
                    z = 1'b1;
                end else begin
                    next_state = 2'b10; // Stay in B
                    z = 1'b0;
                end
            end
        default: // Should not reach here, but for completeness
            begin
                next_state = 2'b01; // Default to state A
                z = 1'b0;
            end
    endcase
end

endmodule
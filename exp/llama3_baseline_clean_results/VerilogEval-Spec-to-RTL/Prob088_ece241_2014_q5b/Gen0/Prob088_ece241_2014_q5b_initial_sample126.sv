module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // One-hot encoding for states A and B
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 2'b01; // Reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b01: // State A
            begin
                if (x == 0) begin
                    next_state = 2'b01; // Stay in A
                    z = 0;
                end else begin
                    next_state = 2'b10; // Go to B
                    z = 1;
                end
            end
        2'b10: // State B
            begin
                if (x == 0) begin
                    next_state = 2'b10; // Stay in B
                    z = 1;
                end else begin
                    next_state = 2'b10; // Stay in B
                    z = 0;
                end
            end
        default: // This should not happen in one-hot encoding
            begin
                next_state = 2'b01; // Default to state A
                z = 0;
            end
    endcase
end

endmodule
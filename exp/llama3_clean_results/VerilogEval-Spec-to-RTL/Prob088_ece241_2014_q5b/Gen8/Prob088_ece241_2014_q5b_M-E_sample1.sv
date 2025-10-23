module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// Counter to encode states (0: State A, 1: State B)
reg [1:0] counter; // Using 2 bits for simplicity and future extensibility

// Output z logic based on counter state and x
always @(*) begin
    if (counter == 2'b0) begin // State A
        z = 1'b0;
    end else if (counter == 2'b1) begin // State B
        z = ~x;
    end else begin // Invalid state, default to 0 (though this should not occur)
        z = 1'b0;
    end
end

// Sequential logic for the counter
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to state A (counter value 0)
        counter <= 2'b0;
    end else begin
        // Transition logic based on x
        if (counter == 2'b0 && x) begin
            // Move to state B if in A and x=1
            counter <= 2'b1;
        end else if (counter == 2'b1) begin
            // Stay in B
            counter <= 2'b1;
        end else begin
            // Stay in A if x=0
            counter <= 2'b0;
        end
    end
end

endmodule
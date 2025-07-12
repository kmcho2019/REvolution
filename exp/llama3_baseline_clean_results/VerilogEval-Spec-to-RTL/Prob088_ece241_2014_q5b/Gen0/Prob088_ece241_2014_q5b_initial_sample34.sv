module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state = 2'b01; // Initialize state to A (using 2 bits for one-hot encoding conceptually)

always @(*) begin
    if(areset) begin // Asynchronous reset
        state <= 2'b01; // Reset to state A
    end else begin
        case(state)
            2'b01: begin // State A
                if(x == 1'b0) begin // If x is 0, stay in A
                    state <= 2'b01;
                    z <= 1'b0;
                end else begin // If x is 1, move to B
                    state <= 2'b10;
                    z <= 1'b1;
                end
            end
            2'b10: begin // State B
                if(x == 1'b0) begin // If x is 0, stay in B
                    state <= 2'b10;
                    z <= 1'b1;
                end else begin // If x is 1, stay in B
                    state <= 2'b10;
                    z <= 1'b0;
                end
            end
            default: begin
                state <= 2'b01; // Default to state A
                z <= 1'b0;
            end
        endcase
    end
end

always @(posedge clk) begin
    // No need for additional logic here as the combinational block above handles state transitions and output based on current state and input.
end

endmodule
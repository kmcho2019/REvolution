module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// One-hot encoding for states A and B
reg [1:0] state;
reg [1:0] next_state;

// Output logic
always @(*) begin
    // Determine z based on current state and x
    if (state == 2'b01) begin // State A
        if (x == 1'b0) begin
            z = 1'b0;
        end else begin
            z = 1'b1;
        end
    end else if (state == 2'b10) begin // State B
        if (x == 1'b0) begin
            z = 1'b1;
        end else begin
            z = 1'b0;
        end
    end else begin
        z = 1'bx; // Undefined for other states
    end
end

// Next state logic
always @(*) begin
    case(state)
        2'b01: begin // State A
            if (x == 1'b0) begin
                next_state = 2'b01; // Remain in A
            end else begin
                next_state = 2'b10; // Transition to B
            end
        end
        2'b10: begin // State B
            next_state = 2'b10; // Remain in B
        end
        default: begin
            next_state = 2'b01; // Reset or undefined state, go to A
        end
    endcase
end

// State update logic with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule
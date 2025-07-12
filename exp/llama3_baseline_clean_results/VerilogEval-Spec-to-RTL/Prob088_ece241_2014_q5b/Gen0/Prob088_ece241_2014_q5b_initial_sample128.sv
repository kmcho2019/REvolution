module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // One-hot encoding: A = 2'b01, B = 2'b10
reg [1:0] next_state;

// Assign initial state due to asynchronous reset
always @(posedge areset or negedge clk) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        // Sequential logic on positive edge of clk, but we are handling reset here
    end
end

// Combinational logic for next state and output
always @(*) begin
    case (state)
        2'b01: begin // State A
            if (x == 0) begin
                next_state = 2'b01; // Stay in A if x = 0
                z = 1'b0;
            end else begin
                next_state = 2'b10; // Move to B if x = 1
                z = 1'b1;
            end
        end
        2'b10: begin // State B
            next_state = 2'b10; // Stay in B regardless of x
            z = x ? 1'b0 : 1'b1;
        end
        default: begin // Default state handling (shouldn't happen in one-hot encoding)
            next_state = 2'b01; // Safe default to A
            z = 1'b0;
        end
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    if (!areset) begin
        state <= next_state;
    end
end

endmodule
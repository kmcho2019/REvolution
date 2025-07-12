module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b00: begin // Initial state
            if (x) begin
                next_state = 2'b01; // Transition to state 1 if x is 1
            end else begin
                next_state = 2'b00; // Stay in state 0 if x is 0
            end
            z = 1'b0; // z is 0 in state 0
        end
        2'b01: begin // Sequence "1" detected
            if (x) begin
                next_state = 2'b01; // Stay in state 1 if x is 1
            end else begin
                next_state = 2'b10; // Transition to state 2 if x is 0
            end
            z = 1'b0; // z is 0 in state 1
        end
        2'b10: begin // Sequence "10" detected
            if (x) begin
                next_state = 2'b01; // Transition to state 1 if x is 1, sequence "101" detected
                z = 1'b1; // Assert z to 1
            end else begin
                next_state = 2'b00; // Reset to state 0 if x is 0
            end
            // z = 1'b0; // z is 0 in state 2 if x is not 1
        end
    endcase
end

endmodule
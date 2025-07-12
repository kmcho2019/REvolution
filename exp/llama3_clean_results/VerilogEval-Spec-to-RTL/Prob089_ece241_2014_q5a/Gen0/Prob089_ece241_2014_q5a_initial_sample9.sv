module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [7:0] state;  // Use 8 bits to store the state and the accumulated input bits
reg [7:0] nextState;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;  // Reset the state and accumulated input bits
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case(state[7])
        0: begin  // Idle state
            if (~areset) begin
                nextState = {1'b1, ~x};  // Transition to Calculating state and accumulate the input bit
            end else begin
                nextState = state;
            end
        end
        1: begin  // Calculating state
            if (areset) begin
                nextState = 0;  // Transition back to Idle state
            end else begin
                nextState = {state[7], ~state[6:0] + x};  // Accumulate the input bit and perform the 2's complement operation
            end
        end
        default: begin
            nextState = state;
        end
    endcase
end

assign z = state[0];  // Output the least significant bit of the accumulated input bits

endmodule
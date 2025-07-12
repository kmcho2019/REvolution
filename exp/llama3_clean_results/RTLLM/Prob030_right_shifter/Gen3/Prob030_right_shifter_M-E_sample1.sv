module right_shifter(
    input clk,  // Clock signal
    input rst_n,  // Active-low reset signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [1:0] state;  // Finite State Machine state register
parameter IDLE = 2'b00, SHIFT = 2'b01;  // FSM states

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        state <= IDLE;  // Return to initial state
        q <= 8'd0;  // Initialize q to 0
    end else begin
        case (state)
            IDLE: begin
                state <= SHIFT;  // Transition to shift state
            end
            SHIFT: begin
                q <= {d, q[7:1]};  // Perform right shift operation
            end
            default: begin
                state <= IDLE;  // Default to initial state
            end
        endcase
    end
end

endmodule
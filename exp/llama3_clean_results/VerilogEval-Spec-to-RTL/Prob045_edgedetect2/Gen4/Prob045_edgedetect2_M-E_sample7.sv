module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [1:0] state [7:0]; // State machine for each bit

always @(posedge clk) begin
    for (int i = 0; i < 8; i++) begin
        case (state[i])
            2'b00: // Initial state, waiting for a 0 to 1 transition
                if (in[i] == 1'b1) begin
                    state[i] <= 2'b01; // Transition to waiting for a 1 to 0 transition
                    anyedge[i] <= 1'b1; // Set output to 1
                end else begin
                    state[i] <= 2'b00; // Stay in initial state
                    anyedge[i] <= 1'b0; // Reset output
                end
            2'b01: // Waiting for a 1 to 0 transition
                if (in[i] == 1'b0) begin
                    state[i] <= 2'b10; // Transition to waiting for a 0 to 1 transition
                    anyedge[i] <= 1'b1; // Set output to 1
                end else begin
                    state[i] <= 2'b01; // Stay in waiting state
                    anyedge[i] <= 1'b0; // Reset output
                end
            2'b10: // Waiting for a 0 to 1 transition
                if (in[i] == 1'b1) begin
                    state[i] <= 2'b01; // Transition to waiting for a 1 to 0 transition
                    anyedge[i] <= 1'b1; // Set output to 1
                end else begin
                    state[i] <= 2'b10; // Stay in waiting state
                    anyedge[i] <= 1'b0; // Reset output
                end
            default: // Invalid state, reset to initial state
                state[i] <= 2'b00;
                anyedge[i] <= 1'b0;
        endcase
    end
end

endmodule
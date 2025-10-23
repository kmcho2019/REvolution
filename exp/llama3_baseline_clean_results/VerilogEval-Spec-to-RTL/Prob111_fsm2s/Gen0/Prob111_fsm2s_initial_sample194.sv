module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

// Define states
reg [1:0] state; // 0: OFF, 1: ON

// Initialize state
initial state = 0;

// Next state logic
always @(*) begin
    case(state)
        0: // OFF state
            begin
                if(j)
                    state <= 1; // Transition to ON
                else
                    state <= 0; // Stay in OFF
            end
        1: // ON state
            begin
                if(k)
                    state <= 0; // Transition to OFF
                else
                    state <= 1; // Stay in ON
            end
    endcase
end

// Assign output
always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to OFF
    end else begin
        // No need to assign next state here, it's done in the @(*) block
        out <= (state == 1) ? 1'b1 : 1'b0; // Determine output based on state
    end
end

endmodule
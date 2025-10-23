module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

// Define the states
reg [0:0] state;

// Initialize the output out
always @(posedge clk) begin
    if(reset) begin
        // Reset to OFF state
        state <= 1'b0; // OFF state is 0, ON state is 1
        out <= 1'b0;
    end else begin
        case(state)
            1'b0: begin // OFF state
                if(j) begin
                    // Transition to ON state when j is high
                    state <= 1'b1;
                    out <= 1'b1;
                end else begin
                    // Stay in OFF state
                    state <= 1'b0;
                    out <= 1'b0;
                end
            end
            1'b1: begin // ON state
                if(k) begin
                    // Transition to OFF state when k is high
                    state <= 1'b0;
                    out <= 1'b0;
                end else begin
                    // Stay in ON state
                    state <= 1'b1;
                    out <= 1'b1;
                end
            end
            default: begin
                // This is to avoid the latch inference warning
                state <= 1'b0;
                out <= 1'b0;
            end
        endcase
    end
end

endmodule
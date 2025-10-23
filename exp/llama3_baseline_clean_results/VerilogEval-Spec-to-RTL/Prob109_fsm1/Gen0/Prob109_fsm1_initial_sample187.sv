module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] current_state; // Using a 1-bit reg to store the current state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronously reset to state B
        current_state <= 1'b1;
    end else begin
        case (current_state)
            1'b0: begin // State A
                if (~in) begin
                    current_state <= 1'b1; // Go to state B if 'in' is 0
                end else begin
                    current_state <= 1'b0; // Stay in state A if 'in' is 1
                end
            end
            1'b1: begin // State B
                if (~in) begin
                    current_state <= 1'b0; // Go to state A if 'in' is 0
                end else begin
                    current_state <= 1'b1; // Stay in state B if 'in' is 1
                end
            end
            default: begin
                current_state <= 1'b1; // Default state is B
            end
        endcase
    end
end

// Determine the output 'out' based on the current state
always @(*) begin
    case (current_state)
        1'b0: out <= 1'b0; // Output is 0 in state A
        1'b1: out <= 1'b1; // Output is 1 in state B
        default: out <= 1'b1; // Default output is 1
    endcase
end

endmodule
module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg current_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b1; // Reset to state B
        out <= 1'b0; // Output for state B
    end else begin
        case(current_state)
            1'b1: begin // State B
                if (in == 1'b0) begin
                    current_state <= 1'b0; // Next state is A
                    out <= 1'b1; // Output for state A
                end else begin
                    current_state <= 1'b1; // Next state is B
                    out <= 1'b0; // Output for state B
                end
            end
            1'b0: begin // State A
                if (in == 1'b0) begin
                    current_state <= 1'b1; // Next state is B
                    out <= 1'b0; // Output for state B
                end else begin
                    current_state <= 1'b0; // Next state is A
                    out <= 1'b1; // Output for state A
                end
            end
        endcase
    end
end

endmodule
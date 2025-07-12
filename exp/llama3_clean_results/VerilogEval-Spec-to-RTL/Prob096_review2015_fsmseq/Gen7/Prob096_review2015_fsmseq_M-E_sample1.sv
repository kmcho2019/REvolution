module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [2:0] state; // State register

// State transition and output logic
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to initial state
        start_shifting <= 0; // Reset start_shifting
    end else begin
        case (state)
            3'b000: begin // Initial state
                if (data) begin
                    state <= 3'b001; // Transition to '1' prefix state
                end else begin
                    state <= 3'b000; // Stay in initial state
                end
            end
            3'b001: begin // '1' prefix state
                if (data) begin
                    state <= 3'b010; // Transition to '11' prefix state
                end else begin
                    state <= 3'b000; // Reset to initial state
                end
            end
            3'b010: begin // '11' prefix state
                if (data) begin
                    state <= 3'b011; // Transition to '110' prefix state
                end else begin
                    state <= 3'b000; // Reset to initial state
                end
            end
            3'b011: begin // '110' prefix state
                if (data) begin
                    state <= 3'b100; // Transition to '1101' prefix state
                    start_shifting <= 1; // Set start_shifting
                end else begin
                    state <= 3'b000; // Reset to initial state
                end
            end
            3'b100: begin // '1101' prefix state
                start_shifting <= 1; // Keep start_shifting set
            end
        endcase
    end
end

endmodule
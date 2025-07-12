module TopModule (
    input         clk,
    input         reset,
    input         data,
    output        start_shifting
);

reg [2:0] state; // IDLE = 3'b000, FOUND_1 = 3'b001, FOUND_11 = 3'b010, FOUND_110 = 3'b011, FOUND_1101 = 3'b100
reg         start_shifting_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to IDLE state
        start_shifting_reg <= 0;
    end else begin
        case (state)
            3'b000: begin // IDLE
                if (data == 1) begin
                    state <= 3'b001; // Transition to FOUND_1
                end
            end
            3'b001: begin // FOUND_1
                if (data == 1) begin
                    state <= 3'b010; // Transition to FOUND_11
                end else if (data == 0) begin
                    state <= 3'b000; // Back to IDLE
                end
            end
            3'b010: begin // FOUND_11
                if (data == 0) begin
                    state <= 3'b011; // Transition to FOUND_110
                end else begin
                    state <= 3'b001; // Back to FOUND_1
                end
            end
            3'b011: begin // FOUND_110
                if (data == 1) begin
                    state <= 3'b100; // Transition to FOUND_1101
                end else begin
                    state <= 3'b000; // Back to IDLE
                end
            end
            3'b100: begin // FOUND_1101
                start_shifting_reg <= 1; // Set start_shifting to 1
                // Remain in this state
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule
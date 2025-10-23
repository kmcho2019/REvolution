module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

reg [1:0] state; // State A: 2'b00, State B: 2'b01, State C: 2'b10, State D: 2'b11
reg [1:0] count; // Counter for clock cycles after entering state B
reg w_count; // Counter for w = 1 occurrences

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        z <= 0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state <= 2'b01; // Move to state B
                    count <= 2'b00; // Reset counter
                    w_count <= 0; // Reset w_count
                end
            end
            2'b01: begin // State B
                if (count == 2'b11) begin // End of 3 clock cycles
                    if (w_count == 2'b10) begin
                        z <= 1; // Set z to 1 if exactly two w = 1 occurrences
                    end else begin
                        z <= 0;
                    end
                    count <= 2'b00; // Reset counter
                    w_count <= 0; // Reset w_count
                end else begin
                    count <= count + 1; // Increment counter
                    if (w) begin
                        w_count <= w_count + 1; // Increment w_count if w = 1
                    end
                end
            end
            default: begin // State C and D
                if (count == 2'b11) begin // End of 3 clock cycles
                    if (w_count == 2'b10) begin
                        z <= 1; // Set z to 1 if exactly two w = 1 occurrences
                    end else begin
                        z <= 0;
                    end
                    count <= 2'b00; // Reset counter
                    w_count <= 0; // Reset w_count
                end else begin
                    count <= count + 1; // Increment counter
                    if (w) begin
                        w_count <= w_count + 1; // Increment w_count if w = 1
                    end
                end
            end
        endcase
    end
end

endmodule
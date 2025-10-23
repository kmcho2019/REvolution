module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2-3: Don't care
reg [1:0] count; // Counter for 4 clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Go to SHIFT state when reset
        count <= 0; // Reset counter
        shift_ena <= 1; // Assert shift_ena
    end else begin
        case (state)
            1: begin // SHIFT state
                shift_ena <= 1; // Assert shift_ena
                count <= count + 1; // Increment counter
                if (count == 3) begin // After 4 clock cycles
                    state <= 0; // Go back to IDLE state
                    count <= 0; // Reset counter
                    shift_ena <= 0; // Deassert shift_ena
                end
            end
            default: begin
                shift_ena <= 0; // Deassert shift_ena in IDLE state
            end
        endcase
    end
end

endmodule
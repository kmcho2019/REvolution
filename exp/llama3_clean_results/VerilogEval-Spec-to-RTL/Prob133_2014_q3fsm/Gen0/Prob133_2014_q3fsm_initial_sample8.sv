module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] counter; // Counter for 3 clock cycles
reg w_count; // Counter for w being 1

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    counter <= 1; // Start counter
                    w_count <= 0;
                end
            end
            1: begin // State B
                if (counter < 3) begin // Within 3 cycles
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                    counter <= counter + 1;
                end else begin // After 3 cycles
                    if (w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    state <= 1; // Remain in state B
                    counter <= 1; // Reset counter
                    w_count <= 0; // Reset w_count
                end
            end
        endcase
    end
end

endmodule
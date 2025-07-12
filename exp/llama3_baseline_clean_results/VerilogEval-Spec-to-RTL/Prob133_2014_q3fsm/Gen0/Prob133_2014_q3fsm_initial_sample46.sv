module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: A, 1: B
reg [1:0] counter; // Counter for clock cycles
reg [1:0] w_count; // Counter for w = 1

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
                    state <= 1; // Transition to state B
                    counter <= 0;
                    w_count <= 0;
                end
                z <= 0;
            end
            1: begin // State B
                if (w) begin
                    w_count <= w_count + 1; // Increment w_count if w = 1
                end
                if (counter == 2) begin // After three clock cycles
                    if (w_count == 2) begin
                        z <= 1; // Set z to 1 if w_count is exactly 2
                    end else begin
                        z <= 0;
                    end
                    counter <= 0; // Reset counter
                    w_count <= 0; // Reset w_count
                end else begin
                    counter <= counter + 1; // Increment counter
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule
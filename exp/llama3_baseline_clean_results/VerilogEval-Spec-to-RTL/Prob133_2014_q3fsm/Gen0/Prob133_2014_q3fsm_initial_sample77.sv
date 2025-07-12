module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0: A, 1: B, 2: count_w
reg [1:0] count; // Count of clock cycles in state B
reg [1:0] w_count; // Count of w = 1 in three clock cycles
reg z_reg; // Register for output z

initial begin
    state = 0; // Initialize state to A
    count = 0;
    w_count = 0;
    z_reg = 0;
end

always @(posedge clk) begin
    if (reset) begin
        state = 0; // Reset to state A
        count = 0;
        w_count = 0;
        z_reg = 0;
    end
    else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state = 1; // Move to state B
                    count = 1; // Start counting clock cycles
                    w_count = w; // Initialize w_count based on w
                end
            end
            1: begin // State B
                if (count < 3) begin // Within the first three cycles
                    count = count + 1;
                    if (w) begin
                        w_count = w_count + 1;
                    end
                end
                else begin // After three cycles
                    if (w_count == 2) begin
                        z_reg = 1; // Set z to 1 if w = 1 exactly twice
                    end
                    else begin
                        z_reg = 0; // Otherwise, set z to 0
                    end
                    state = 1; // Stay in state B
                    count = 1; // Reset cycle count
                    w_count = w; // Reset w_count based on current w
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule
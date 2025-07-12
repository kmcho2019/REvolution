module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // 0 - A, 1 - B
reg [2:0] w_count; // Counter for w = 1 in the last three cycles
reg [2:0] cycle_count; // Counter for the three cycles in state B
reg z_reg; // Register for output z

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset state to A
        w_count <= 0;
        cycle_count <= 0;
        z_reg <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                    w_count <= 0;
                    cycle_count <= 1;
                    z_reg <= 0;
                end
            end
            1: begin // State B
                if (w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if (cycle_count == 3) begin
                    // Determine z based on w_count
                    if (w_count == 2) begin
                        z_reg <= 1;
                    end else begin
                        z_reg <= 0;
                    end
                    w_count <= 0;
                    cycle_count <= 1;
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule
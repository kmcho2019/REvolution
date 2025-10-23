module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0 - A, 1 - B
reg [1:0] w_count; // Counter for w = 1 occurrences
reg [1:0] cycle_count; // Counter for the three clock cycles
reg z_flag; // Flag to set z = 1

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        w_count <= 0;
        cycle_count <= 0;
        z_flag <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                    w_count <= 0;
                    cycle_count <= 1;
                    z_flag <= 0;
                end
            end
            1: begin // State B
                if (cycle_count < 3) begin
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                    cycle_count <= cycle_count + 1;
                end else begin
                    if (w_count == 2) begin
                        z_flag <= 1;
                    end else begin
                        z_flag <= 0;
                    end
                    w_count <= 0;
                    cycle_count <= 1;
                end
            end
        endcase
        if (cycle_count == 3) begin
            z <= z_flag;
        end else begin
            z <= 0;
        end
    end
end

endmodule
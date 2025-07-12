module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B (counting), 2: State B (output based on count)
reg [1:0] w_count; // Count of w = 1 in three cycles
reg [1:0] cycle_count; // Current cycle count (0 to 2)

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0; // Reset to state A
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Move to state B
                    w_count <= 0;
                    cycle_count <= 0;
                end
            end
            1: begin // State B (counting)
                if(cycle_count < 3) begin
                    if(w) begin
                        w_count <= w_count + 1;
                    end
                    cycle_count <= cycle_count + 1;
                    state <= 1;
                end else begin // After 3 cycles, determine z
                    if(w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    state <= 2; // Move to output state
                end
            end
            2: begin // State B (output)
                z <= 0; // Reset z
                state <= 1; // Go back to counting state
                w_count <= 0;
                cycle_count <= 0;
            end
        endcase
    end
end

endmodule
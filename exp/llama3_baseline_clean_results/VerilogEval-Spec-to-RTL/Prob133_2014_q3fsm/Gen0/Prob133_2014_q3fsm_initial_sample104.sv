module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B, 2: Not needed but included for completeness, 
                 //     as state machine can be defined with more states but here we manage with fewer
reg [1:0] count; // Counter for w=1 over three cycles
reg [1:0] cycle; // Counter for the three cycles
reg flag; // Flag to indicate if we've seen exactly two w=1

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        count <= 0;
        cycle <= 0;
        flag <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    count <= 0;
                    cycle <= 1;
                    flag <= 0;
                    z <= 0;
                end
            end
            1: begin // State B
                if (w) count <= count + 1; // Increment count if w=1
                cycle <= cycle + 1; // Increment cycle count
                if (cycle == 3) begin
                    cycle <= 1; // Reset cycle count
                    if (count == 2) begin
                        flag <= 1; // Set flag if exactly two w=1 were seen
                    end else begin
                        flag <= 0;
                    end
                    count <= 0; // Reset count for next cycle
                end
            end
        endcase
        if (flag) begin
            z <= 1; // Set z=1 if flag is set
        end else begin
            z <= 0;
        end
        if (flag) flag <= 0; // Reset flag after setting z
    end
end

endmodule
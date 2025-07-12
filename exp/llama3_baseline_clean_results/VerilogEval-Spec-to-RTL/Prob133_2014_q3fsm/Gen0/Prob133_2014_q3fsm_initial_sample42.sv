module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State register (A = 2'b00, B = 2'b01, counting states within B are managed by counters)
reg [1:0] count_w; // Counter for w = 1 within the 3 cycles
reg [1:0] cycle_count; // Counter for the 3 clock cycles in state B
reg z_next; // Next value of z

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        count_w <= 2'b00;
        cycle_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state <= 2'b01; // Transition to state B
                    count_w <= 2'b00;
                    cycle_count <= 2'b01; // Start cycle count
                end
            end
            2'b01: begin // State B
                if (w) begin
                    count_w <= count_w + 1'b1; // Increment count if w = 1
                end
                if (cycle_count == 2'b11) begin // End of 3 cycles
                    state <= 2'b01; // Stay in state B
                    cycle_count <= 2'b01; // Reset cycle count
                    if (count_w == 2'b10) begin // Exactly two w = 1
                        z_next <= 1'b1;
                    end else begin
                        z_next <= 1'b0;
                    end
                    count_w <= 2'b00; // Reset w count
                end else begin
                    cycle_count <= cycle_count + 1'b1; // Increment cycle count
                end
            end
            default: state <= 2'b00; // Default to state A
        endcase
        z <= z_next; // Update z
    end
end

endmodule
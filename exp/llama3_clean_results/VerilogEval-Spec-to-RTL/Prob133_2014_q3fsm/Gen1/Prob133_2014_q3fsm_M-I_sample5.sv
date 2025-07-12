module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A = 2'b00, State B = 2'b01
reg [1:0] cycle_count; // Counter for three clock cycles
reg [1:0] w_count; // Counter for w = 1 occurrences
reg set_z; // Flag to set z in the next cycle

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00; // Reset to state A
        cycle_count <= 2'b00;
        w_count <= 2'b00;
        set_z <= 1'b0;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Move to state B
                    cycle_count <= 2'b01; // Start cycle counter
                    w_count <= 2'b00; // Reset w counter
                    set_z <= 1'b0;
                end else begin
                    state <= 2'b00; // Stay in state A
                end
            end
            2'b01: begin // State B
                if(cycle_count == 2'b11) begin // End of three clock cycles
                    if(w_count == 2'b10) begin // Exactly two w = 1 occurrences
                        set_z <= 1'b1;
                    end else begin
                        set_z <= 1'b0;
                    end
                    cycle_count <= 2'b00; // Reset cycle counter
                    w_count <= 2'b00; // Reset w counter
                end else begin
                    if(w) begin
                        w_count <= w_count + 1'b1; // Increment w counter if w = 1
                    end
                    cycle_count <= cycle_count + 1'b1; // Increment cycle counter
                end
                if(set_z) begin
                    z <= 1'b1;
                    set_z <= 1'b0;
                end else begin
                    z <= 1'b0;
                end
            end
            default: begin
                state <= 2'b00; // Default back to state A
            end
        endcase
    end
end

endmodule
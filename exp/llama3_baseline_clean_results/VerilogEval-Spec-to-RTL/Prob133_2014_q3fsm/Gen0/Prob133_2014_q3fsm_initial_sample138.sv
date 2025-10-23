module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // States: 2'b00 - A, 2'b01 - B, 2'b10 - B (checking w)
reg [1:0] w_count; // Counter for w = 1 occurrences
reg [1:0] cycle_count; // Counter for clock cycles while checking w

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00; // Reset to state A
        w_count <= 2'b00;
        cycle_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Move to state B
                    w_count <= 2'b00;
                    cycle_count <= 2'b01;
                end else begin
                    state <= 2'b00; // Stay in state A
                end
                z <= 1'b0;
            end
            2'b01: begin // State B (start checking w)
                if(w) begin
                    w_count <= w_count + 1'b1;
                end
                cycle_count <= cycle_count + 1'b1;
                if(cycle_count == 2'b11) begin // End of 3 cycles
                    state <= 2'b10; // Move to state to set z
                end else begin
                    state <= 2'b01; // Continue in state B
                end
            end
            2'b10: begin // State to set z
                if(w_count == 2'b10) begin // Exactly two w = 1 occurrences
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
                state <= 2'b01; // Go back to checking w
                w_count <= 2'b00;
                cycle_count <= 2'b01;
            end
        endcase
    end
end

endmodule
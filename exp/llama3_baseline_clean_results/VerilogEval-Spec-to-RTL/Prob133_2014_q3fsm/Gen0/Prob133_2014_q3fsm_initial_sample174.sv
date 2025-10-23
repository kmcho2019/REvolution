module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] count_w; // Counter for w = 1 within the 3 cycles
reg [1:0] cycle_count; // Counter for the 3 cycles
reg state_A; // State A flag

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_A <= 1'b1; // Reset to state A
        count_w <= 2'b00;
        cycle_count <= 2'b00;
        z <= 1'b0;
    end else begin
        if (state_A) begin
            if (s) begin
                state_A <= 1'b0; // Transition to state B
            end
        end else begin // In state B
            if (cycle_count == 3'b111) begin // End of 3 cycles
                if (count_w == 2'b10) begin // Exactly two w = 1s
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
                cycle_count <= 2'b00; // Reset cycle count
                count_w <= 2'b00; // Reset w count
            end else begin
                if (w) begin
                    count_w <= count_w + 1'b1; // Increment w count if w = 1
                end
                cycle_count <= cycle_count + 1'b1; // Increment cycle count
            end
        end
    end
end

endmodule
module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // Current state (0: A, 1: B)
reg [2:0] count_w; // Count of w in three cycles
reg [1:0] cycle; // Cycle counter

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state to A
        count_w <= 0; // Reset count of w
        cycle <= 0; // Reset cycle counter
        z <= 0; // Reset z
    end
    else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Transition to state B
                    count_w <= 0; // Reset count of w
                    cycle <= 1; // Reset cycle counter
                end
            end
            1: begin // State B
                if(w) begin
                    count_w <= count_w + 1; // Increment count of w
                end
                if(cycle == 3) begin
                    z <= (count_w == 2) ? 1 : 0; // Set z based on count of w
                    count_w <= 0; // Reset count of w
                    cycle <= 1; // Reset cycle counter
                end
                else begin
                    cycle <= cycle + 1; // Increment cycle counter
                end
            end
        endcase
    end
end

endmodule
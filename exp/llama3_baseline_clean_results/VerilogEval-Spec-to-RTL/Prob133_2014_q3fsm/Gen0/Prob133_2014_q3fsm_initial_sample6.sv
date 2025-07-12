module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State variable: 0 - A, 1 - B
reg [1:0] count_w; // Counter for w = 1 occurrences
reg [1:0] cycle_count; // Counter for the current cycle within the 3-cycle window

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0; // Reset to state A
        count_w <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Transition to state B
                    count_w <= 0;
                    cycle_count <= 1;
                end
                z <= 0;
            end
            1: begin // State B
                if(cycle_count < 3) begin // Still within the 3-cycle window
                    if(w) begin
                        count_w <= count_w + 1;
                    end
                    cycle_count <= cycle_count + 1;
                end else begin // End of the 3-cycle window
                    if(count_w == 2) begin
                        z <= 1; // Set z to 1 if w was 1 exactly twice
                    end else begin
                        z <= 0;
                    end
                    count_w <= w ? 1 : 0; // Reset count_w for the next window, considering the current w
                    cycle_count <= 1; // Reset cycle_count for the next window
                end
            end
        endcase
    end
end

endmodule
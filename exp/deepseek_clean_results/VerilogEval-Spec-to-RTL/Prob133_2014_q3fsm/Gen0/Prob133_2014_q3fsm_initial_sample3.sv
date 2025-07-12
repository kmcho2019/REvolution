module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
typedef enum {A, B} state_t;
reg state;
reg [1:0] cycle_count;  // Counts 0-2 for 3 cycles
reg [1:0] w_count;      // Counts w=1 occurrences

always @(posedge clk) begin
    if (reset) begin
        state <= A;
        cycle_count <= 2'b0;
        w_count <= 2'b0;
        z <= 1'b0;
    end else begin
        case (state)
            A: begin
                z <= 1'b0;
                if (s) begin
                    state <= B;
                    cycle_count <= 2'b0;
                    w_count <= 2'b0;
                end
            end
            
            B: begin
                if (cycle_count < 2'b10) begin  // 0,1 cycles
                    cycle_count <= cycle_count + 1'b1;
                    if (w) w_count <= w_count + 1'b1;
                    z <= 1'b0;
                end else begin  // 2nd cycle (completes 3 cycles)
                    // Check if exactly 2 w=1 occurred
                    z <= (w_count + w) == 2'b10;
                    // Reset counters for next 3-cycle window
                    cycle_count <= 2'b0;
                    w_count <= 2'b0;
                end
            end
        endcase
    end
end

endmodule
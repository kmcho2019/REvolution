module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
typedef enum logic {A, B} state_t;
state_t current_state, next_state;

// Counters
reg [1:0] cycle_count;  // Counts 0-2 for 3-cycle windows
reg [1:0] w_count;      // Counts w=1 occurrences in current window

always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
        cycle_count <= 2'b0;
        w_count <= 2'b0;
        z <= 1'b0;
    end
    else begin
        current_state <= next_state;
        
        case (current_state)
            A: begin
                // Reset counters when in state A
                cycle_count <= 2'b0;
                w_count <= 2'b0;
                z <= 1'b0;
            end
            
            B: begin
                if (cycle_count == 2'b10) begin
                    // End of 3-cycle window
                    z <= (w_count == 2'b10);  // Set z if exactly two w=1
                    cycle_count <= 2'b0;
                    w_count <= 2'b0;
                end
                else begin
                    cycle_count <= cycle_count + 1;
                    z <= 1'b0;
                end
                
                // Count w=1 in current cycle
                if (w) w_count <= w_count + 1;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        A: next_state = s ? B : A;
        B: next_state = B;  // Always stay in B once entered
        default: next_state = A;
    endcase
end

endmodule
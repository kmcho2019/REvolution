module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // Define states
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state, next_state;
    reg [1:0] cycle_count;  // Tracks 0-2 cycles in state B
    reg [1:0] w_count;      // Counts w=1 in current window
    
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                A: begin
                    // Reset counters when in state A
                    cycle_count <= 2'b00;
                    w_count <= 2'b00;
                    z <= 1'b0;
                end
                B: begin
                    if (cycle_count == 2'b10) begin
                        // End of window - evaluate w_count
                        z <= (w_count == 2'b10);  // Set z if exactly two w=1
                        cycle_count <= 2'b00;      // Reset for new window
                        w_count <= (w ? 2'b01 : 2'b00);  // Start new count with current w
                    end else begin
                        cycle_count <= cycle_count + 1;
                        if (w) w_count <= w_count + 1;
                        z <= 1'b0;  // Default z to 0 during counting
                    end
                end
            endcase
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = s ? B : A;
            B: next_state = B;  // Once in B, stay in B
            default: next_state = A;
        endcase
    end

endmodule
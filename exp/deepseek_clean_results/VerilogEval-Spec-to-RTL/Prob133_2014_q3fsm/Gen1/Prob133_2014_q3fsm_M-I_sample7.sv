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
    reg [2:0] w_history;    // Shift register for last 3 w values
    reg evaluate;           // Flag to indicate evaluation needed
    
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_history <= 3'b000;
            evaluate <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                A: begin
                    // Reset all counters when in state A
                    cycle_count <= 2'b00;
                    w_history <= 3'b000;
                    evaluate <= 1'b0;
                    z <= 1'b0;
                end
                B: begin
                    // Shift in new w value
                    w_history <= {w_history[1:0], w};
                    
                    if (cycle_count == 2'b10) begin
                        // End of window - set evaluation flag
                        evaluate <= 1'b1;
                        cycle_count <= 2'b00;
                    end else begin
                        cycle_count <= cycle_count + 1;
                        evaluate <= 1'b0;
                    end
                    
                    // Set z based on previous evaluation
                    z <= evaluate ? ($countones(w_history) == 2) : 1'b0;
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
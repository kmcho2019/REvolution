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
    reg [2:0] w_window;
    reg [1:0] cycle_count;
    reg window_eval;
    
    // State transition and counter logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_window <= 3'b0;
            cycle_count <= 2'b0;
            window_eval <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Shift in new w value
                w_window <= {w_window[1:0], w};
                
                // Increment cycle counter
                if (cycle_count == 2'd2) begin
                    cycle_count <= 2'd0;
                end else begin
                    cycle_count <= cycle_count + 1;
                end
                
                // Evaluate window one cycle before setting z
                if (cycle_count == 2'd2) begin
                    window_eval <= (w_window[0] + w_window[1] + w_window[2]) == 2'd2;
                end
                
                // Set z based on previous window evaluation
                z <= window_eval;
                
                // Clear evaluation after use
                if (cycle_count == 2'd0) begin
                    window_eval <= 1'b0;
                end
            end else begin
                w_window <= 3'b0;
                cycle_count <= 2'b0;
                window_eval <= 1'b0;
                z <= 1'b0;
            end
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = s ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

endmodule
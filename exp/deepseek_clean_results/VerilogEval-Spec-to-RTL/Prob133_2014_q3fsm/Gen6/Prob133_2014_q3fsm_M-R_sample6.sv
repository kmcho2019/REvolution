module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    reg [1:0] cycle_count;  // Counts 0-2 cycles in state B
    reg [2:0] w_history;    // Stores last 3 w values
    reg evaluation_flag;     // Indicates when to evaluate
    
    // Next state logic (combinational)
    wire next_state;
    assign next_state = (state == A) ? (s ? B : A) : B;
    
    // Output logic (combinational)
    assign z = (state == B) ? evaluation_flag && ($countones(w_history) == 2) : 1'b0;
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_history <= 3'b000;
            evaluation_flag <= 1'b0;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Shift in new w value
                w_history <= {w_history[1:0], w};
                
                // Update cycle counter
                if (cycle_count == 2'b10) begin
                    cycle_count <= 2'b00;
                end else begin
                    cycle_count <= cycle_count + 1;
                end
                
                // Set evaluation flag one cycle after window completes
                evaluation_flag <= (cycle_count == 2'b10);
            end else begin
                // Reset counters when in state A
                cycle_count <= 2'b00;
                w_history <= 3'b000;
                evaluation_flag <= 1'b0;
            end
        end
    end

endmodule
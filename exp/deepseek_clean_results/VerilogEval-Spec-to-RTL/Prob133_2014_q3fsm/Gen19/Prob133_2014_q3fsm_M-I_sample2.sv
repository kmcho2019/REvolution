module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Shift register for last 3 w values
    reg [2:0] w_history;
    
    // Cycle counter
    reg [1:0] cycle_count;

    // State transition logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Detect exactly two 1's in w_history
    wire two_ones = (w_history == 3'b011) || 
                   (w_history == 3'b101) || 
                   (w_history == 3'b110);

    // Output logic - active when window completes and has exactly two 1's
    assign z = (state == B) && (cycle_count == 2'd2) && two_ones;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
            cycle_count <= 2'b00;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update cycle counter with wrap-around
                cycle_count <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1'b1);
                
                // Shift in new w value at each cycle
                if (cycle_count == 2'd2)
                    w_history <= {w_history[1:0], w};
                else
                    w_history <= {w_history[1:0], w};
            end else begin
                // Reset counters when in state A
                w_history <= 3'b000;
                cycle_count <= 2'b00;
            end
        end
    end

endmodule
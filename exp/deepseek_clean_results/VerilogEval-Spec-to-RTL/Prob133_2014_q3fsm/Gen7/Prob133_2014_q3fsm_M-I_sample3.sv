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
    reg cycle_flag;         // Toggles every 3 cycles in state B
    reg [2:0] w_history;    // Stores last 3 w values
    reg two_ones;           // Pre-computed condition
    
    // Next state logic (combinational)
    wire next_state;
    assign next_state = (state == A) ? (s ? B : A) : B;
    
    // Output logic (combinational)
    assign z = (state == B) ? cycle_flag && two_ones : 1'b0;
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_flag <= 1'b0;
            w_history <= 3'b000;
            two_ones <= 1'b0;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Shift in new w value and update history
                w_history <= {w_history[1:0], w};
                
                // Toggle cycle_flag every 3 cycles (acts as modulo-3 counter)
                cycle_flag <= ~cycle_flag;
                
                // Pre-compute two_ones condition
                case (w_history)
                    3'b011, 3'b101, 3'b110: two_ones <= 1'b1;
                    default: two_ones <= 1'b0;
                endcase
            end else begin
                // Reset counters when in state A
                cycle_flag <= 1'b0;
                w_history <= 3'b000;
                two_ones <= 1'b0;
            end
        end
    end

endmodule
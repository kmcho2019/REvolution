module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
typedef enum {A, B} state_t;
reg [1:0] state, next_state;
reg [2:0] window;        // 3-bit sliding window
reg [1:0] cycle_count;   // Tracks 0-2 cycles in state B
reg eval_next_cycle;     // Flag to evaluate in next cycle

// Combinational ones count
wire [1:0] ones_count = window[0] + window[1] + window[2];

always @(posedge clk) begin
    if (reset) begin
        state <= A;
        window <= 3'b0;
        cycle_count <= 2'b0;
        eval_next_cycle <= 1'b0;
        z <= 1'b0;
    end else begin
        state <= next_state;
        
        // State B processing
        if (state == B) begin
            // Shift in new w value
            window <= {window[1:0], w};
            
            // Track cycles (0,1,2)
            if (cycle_count == 2'd2) begin
                cycle_count <= 2'd0;
                eval_next_cycle <= 1'b1;  // Will evaluate next cycle
            end else begin
                cycle_count <= cycle_count + 1'b1;
                eval_next_cycle <= 1'b0;
            end
        end else begin
            // State A - reset counters
            window <= 3'b0;
            cycle_count <= 2'b0;
            eval_next_cycle <= 1'b0;
        end
        
        // Output generation (registered)
        z <= eval_next_cycle && (ones_count == 2'd2);
    end
end

always_comb begin
    next_state = state;
    case (state)
        A: if (s) next_state = B;
        B: next_state = B;  // Stay in B once entered
    endcase
end

endmodule
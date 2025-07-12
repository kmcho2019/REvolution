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

    // Window tracking
    reg [1:0] cycle_count;  // Modulo-3 counter (0-2)
    reg [2:0] w_window;     // Last 3 w values
    reg [1:0] ones_count;   // Stored count of 1's in window

    // Next state logic (combinational)
    wire next_state = reset ? A : (state == A) ? (s ? B : A) : B;

    // Terminal count detection
    wire window_complete = (cycle_count == 2'd2);

    // Output logic (combinational)
    assign z = (state == B) && window_complete && (ones_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_window <= 3'b000;
            ones_count <= 2'b00;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update window and counter
                w_window <= {w_window[1:0], w};
                cycle_count <= window_complete ? 2'd0 : (cycle_count + 1'b1);
                
                // Update ones count only when window completes
                if (window_complete) begin
                    ones_count <= w_window[0] + w_window[1] + w;
                end
            end else begin
                // Reset counters in state A
                cycle_count <= 2'b00;
                w_window <= 3'b000;
                ones_count <= 2'b00;
            end
        end
    end

endmodule
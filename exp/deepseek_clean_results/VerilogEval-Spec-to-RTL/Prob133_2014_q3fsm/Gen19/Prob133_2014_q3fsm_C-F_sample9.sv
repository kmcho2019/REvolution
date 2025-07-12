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

    // Counting registers
    reg [1:0] cycle_count;  // Tracks position in 3-cycle window (0-2)
    reg [1:0] w_count;      // Counts number of 1's in current window
    reg [1:0] w_history;    // Stores last 2 w values (current window)

    // State transition logic
    wire next_state = reset ? A : (state == A) ? (s ? B : A) : B;

    // Output logic - evaluate when starting new window
    assign z = (state == B) && (cycle_count == 2'd0) && (w_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_count <= 2'b00;
            w_history <= 2'b00;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update cycle counter with modulo-3 behavior
                cycle_count <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1'b1);
                
                // Update w history and count
                if (cycle_count == 2'd0) begin
                    // New window - reset count and store first w
                    w_count <= w;
                    w_history <= {1'b0, w};
                end else begin
                    // Shift in new w and update count if needed
                    w_history <= {w_history[0], w};
                    if (w) begin
                        w_count <= w_count + 1'b1;
                    end
                end
            end else begin
                // Reset counters when in state A
                cycle_count <= 2'b00;
                w_count <= 2'b00;
                w_history <= 2'b00;
            end
        end
    end

endmodule
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
    reg [1:0] ones_count;   // Counts number of 1's in current window

    // State transition logic (combinational)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic - evaluate when starting new window (cycle_count wraps)
    assign z = (state == B) && (cycle_count == 2'd0) && (ones_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            ones_count <= 2'b00;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update cycle counter with modulo-3 behavior
                cycle_count <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1'b1);
                
                // Update ones counter only when needed
                if (cycle_count == 2'd0) begin
                    ones_count <= w;  // Start new window
                end else if (w) begin
                    ones_count <= ones_count + 1'b1;
                end
            end else begin
                // Reset counters when in state A
                cycle_count <= 2'b00;
                ones_count <= 2'b00;
            end
        end
    end

endmodule
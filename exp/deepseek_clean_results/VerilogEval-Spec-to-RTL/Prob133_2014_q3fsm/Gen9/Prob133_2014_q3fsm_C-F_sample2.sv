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

    // Counting mechanisms
    reg [1:0] cycle_count;  // Modulo-3 counter (0-2)
    reg [1:0] ones_count;   // Count of 1's in current window

    // State transition logic (combinational)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic (combinational) - evaluate only at window boundary
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
                // Update cycle counter with wrap-around
                cycle_count <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1'b1);
                
                // Efficient ones counting - reset or conditional increment
                if (cycle_count == 2'd0)
                    ones_count <= w;  // Start new window
                else if (w)
                    ones_count <= ones_count + 1'b1;  // Increment only when w=1
            end else begin
                // Reset counters when in state A
                cycle_count <= 2'b00;
                ones_count <= 2'b00;
            end
        end
    end

endmodule
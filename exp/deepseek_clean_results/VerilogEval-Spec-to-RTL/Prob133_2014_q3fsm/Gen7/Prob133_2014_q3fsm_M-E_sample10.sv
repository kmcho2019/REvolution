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
    reg [2:0] w_pattern;   // Stores last 3 w values

    // Predefined patterns with exactly two 1's
    wire pattern_match = (w_pattern == 3'b011) ||  // Patterns with
                        (w_pattern == 3'b101) ||  // exactly two 1's
                        (w_pattern == 3'b110);

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic - check pattern at window boundary
    assign z = (state == B) && (cycle_count == 2'd0) && pattern_match;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_pattern <= 3'b000;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Shift in new w value
                w_pattern <= {w_pattern[1:0], w};
                
                // Update modulo-3 counter
                cycle_count <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1'b1);
            end else begin
                // Reset tracking in state A
                cycle_count <= 2'b00;
                w_pattern <= 3'b000;
            end
        end
    end

endmodule
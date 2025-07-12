module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State definitions
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window tracking
    reg [2:0] w_samples;
    reg toggle;
    
    // Valid patterns for exactly two 1's
    wire pattern_match = (w_samples == 3'b011) || 
                         (w_samples == 3'b101) || 
                         (w_samples == 3'b110);

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_samples <= 3'b0;
            toggle <= 1'b0;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Shift in new w value and update toggle
                w_samples <= {w_samples[1:0], w};
                toggle <= ~toggle;
            end else begin
                // Reset tracking in state A
                w_samples <= 3'b0;
                toggle <= 1'b0;
            end
        end
    end

    // Output logic - evaluate when toggle wraps around
    assign z = (state == B) && toggle && pattern_match;

endmodule
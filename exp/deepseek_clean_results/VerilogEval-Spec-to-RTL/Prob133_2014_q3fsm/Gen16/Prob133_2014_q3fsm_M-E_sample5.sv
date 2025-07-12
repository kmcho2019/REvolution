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
    reg history_valid;  // Tracks when we have 3 valid bits

    // State transition logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Detect exactly two 1's in w_history
    wire exactly_two_ones = 
        (w_history == 3'b011) || 
        (w_history == 3'b101) || 
        (w_history == 3'b110);

    // Output is asserted when we have valid history and exactly two 1's
    assign z = (state == B) && history_valid && exactly_two_ones;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
            history_valid <= 1'b0;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Shift in new w value
                w_history <= {w_history[1:0], w};
                
                // Track when we have 3 valid bits
                if (!history_valid) begin
                    history_valid <= &{w_history[1:0], 1'b1};  // Set when all bits filled
                end
            end else begin
                // Reset tracking when in state A
                w_history <= 3'b000;
                history_valid <= 1'b0;
            end
        end
    end

endmodule
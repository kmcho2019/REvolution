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

    // Window tracking (toggles every 3 cycles)
    reg window_toggle;

    // State transition logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Detect exactly two 1's in w_history (6 possible combinations)
    wire exactly_two_ones = 
        (w_history == 3'b011) || (w_history == 3'b101) || 
        (w_history == 3'b110) || (w_history == 3'b001) || 
        (w_history == 3'b010) || (w_history == 3'b100);

    // Output logic - active at window boundaries when exactly two 1's
    assign z = (state == B) && window_toggle && exactly_two_ones;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
            window_toggle <= 1'b0;
        end else begin
            state <= next_state;

            if (state == B) begin
                // Shift in new w value
                w_history <= {w_history[1:0], w};

                // Toggle every 3 cycles to mark window boundaries
                window_toggle <= (w_history[0] ^ w_history[1] ^ w_history[2]) ? ~window_toggle : window_toggle;
            end else begin
                // Reset tracking when in state A
                w_history <= 3'b000;
                window_toggle <= 1'b0;
            end
        end
    end

endmodule
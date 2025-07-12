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

    // Modulo-3 counter (0-2)
    reg [1:0] cycle_count;

    // Pattern matching logic
    wire pattern_match = (w_history == 3'b011) || 
                        (w_history == 3'b101) || 
                        (w_history == 3'b110);

    // Output logic
    assign z = (state == B) && (cycle_count == 2'd0) && pattern_match;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
            cycle_count <= 2'b00;
        end else begin
            // State transition
            state <= (state == A) ? (s ? B : A) : B;

            // In state B, update shift register and counter
            if (state == B) begin
                w_history <= {w_history[1:0], w};
                
                if (cycle_count == 2'd2)
                    cycle_count <= 2'd0;
                else
                    cycle_count <= cycle_count + 1'b1;
            end else begin
                // Reset in state A
                w_history <= 3'b000;
                cycle_count <= 2'b00;
            end
        end
    end

endmodule
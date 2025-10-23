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

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic - set z when we've seen exactly two 1's in last 3 cycles
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
                // Update cycle counter
                if (cycle_count == 2'd2)
                    cycle_count <= 2'd0;
                else
                    cycle_count <= cycle_count + 1'b1;
                
                // Update ones counter
                if (cycle_count == 2'd0)
                    ones_count <= w;
                else
                    ones_count <= ones_count + w;
            end else begin
                // Reset counters in state A
                cycle_count <= 2'b00;
                ones_count <= 2'b00;
            end
        end
    end

endmodule
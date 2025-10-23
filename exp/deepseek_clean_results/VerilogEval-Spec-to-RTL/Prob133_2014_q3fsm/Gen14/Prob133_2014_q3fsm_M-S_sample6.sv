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
    reg [1:0] ones_count;   // Count of 1's in current window

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic
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
                // Update counters
                if (cycle_count == 2'd2) begin
                    cycle_count <= 2'd0;
                    ones_count <= w;  // Start new window
                end else begin
                    cycle_count <= cycle_count + 1'b1;
                    ones_count <= ones_count + w;
                end
            end else begin
                // Reset counters in state A
                cycle_count <= 2'b00;
                ones_count <= 2'b00;
            end
        end
    end

endmodule
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
    reg [1:0] w_count;      // Count of 1's in current window

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic - check count at window boundary
    assign z = (state == B) && (cycle_count == 2'd2) && (w_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_count <= 2'b00;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update cycle counter
                cycle_count <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1'b1);
                
                // Update w count
                if (cycle_count == 2'd2) begin
                    w_count <= 2'b00;  // Reset at window boundary
                end else if (w) begin
                    w_count <= w_count + 1'b1;
                end
            end else begin
                // Reset tracking in state A
                cycle_count <= 2'b00;
                w_count <= 2'b00;
            end
        end
    end

endmodule
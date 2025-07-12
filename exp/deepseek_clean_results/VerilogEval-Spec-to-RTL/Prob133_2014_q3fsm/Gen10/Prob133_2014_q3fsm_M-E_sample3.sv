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
    reg [1:0] ones_count;  // Count of 1's in current window
    reg window_bit;        // Tracks position in 3-cycle window (0,1,2)

    // Next state logic (combinational)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic (combinational)
    assign z = (state == B) && (window_bit == 1'b0) && (ones_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            ones_count <= 2'b00;
            window_bit <= 1'b0;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update ones counter when w is 1
                if (w) begin
                    ones_count <= ones_count + 1'b1;
                end

                // Update window position
                window_bit <= ~window_bit;

                // Reset counters at end of 3-cycle window
                if (window_bit == 1'b1) begin
                    ones_count <= 2'b00;
                end
            end else begin
                // Reset counters in state A
                ones_count <= 2'b00;
                window_bit <= 1'b0;
            end
        end
    end

endmodule
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

    // Modulo-3 counter for window tracking
    reg [1:0] cycle_count;

    // Circular buffer for window values
    reg [2:0] window_buffer;
    reg [1:0] write_ptr;

    // Running count of 1s in current window
    reg [1:0] ones_count;

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic - active at window boundaries when count is exactly 2
    assign z = (state == B) && (cycle_count == 2'd2) && (ones_count == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            window_buffer <= 3'b000;
            write_ptr <= 2'd0;
            ones_count <= 2'd0;
        end else begin
            state <= next_state;

            if (state == B) begin
                // Update circular buffer and running count
                if (cycle_count == 2'd2) begin
                    // Subtract oldest value when window rolls over
                    ones_count <= ones_count - window_buffer[write_ptr];
                end

                // Store new value and update count
                window_buffer[write_ptr] <= w;
                ones_count <= ones_count + w;

                // Update pointers and counters
                cycle_count <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1'b1);
                write_ptr <= (write_ptr == 2'd2) ? 2'd0 : (write_ptr + 1'b1);

                // Special handling for window rollover
                if (cycle_count == 2'd2) begin
                    ones_count <= ones_count - window_buffer[write_ptr] + w;
                end
            end else begin
                // Reset all counters when in state A
                cycle_count <= 2'd0;
                window_buffer <= 3'b000;
                write_ptr <= 2'd0;
                ones_count <= 2'd0;
            end
        end
    end

endmodule
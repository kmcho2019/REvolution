module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg current_state;
    wire next_state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Counting mechanisms
    reg [1:0] cycle_count;  // Modulo-3 counter (0-2)
    reg [1:0] ones_count;   // Count of 1's in current window
    wire window_end = (cycle_count == 2'd2);

    // State transition logic
    assign next_state = (current_state == A) ? (s ? B : A) : B;

    // Output logic - active when window ends and exactly two 1's were seen
    assign z = (current_state == B) && window_end && (ones_count == 2'd2);

    // State register
    always @(posedge clk) begin
        if (reset) current_state <= A;
        else current_state <= next_state;
    end

    // Cycle counter
    always @(posedge clk) begin
        if (reset || current_state == A)
            cycle_count <= 2'b00;
        else if (current_state == B)
            cycle_count <= window_end ? 2'd0 : (cycle_count + 1'b1);
    end

    // Ones counter
    always @(posedge clk) begin
        if (reset || current_state == A)
            ones_count <= 2'b00;
        else if (current_state == B) begin
            if (window_end)
                ones_count <= w;  // Start new window
            else
                ones_count <= ones_count + w;
        end
    end

endmodule
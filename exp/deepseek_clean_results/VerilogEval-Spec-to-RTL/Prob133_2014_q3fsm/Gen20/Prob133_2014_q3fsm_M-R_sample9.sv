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

    // Counting registers
    reg [1:0] cycle_count;
    reg [1:0] ones_count;

    // Combinational next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Window completion detection
    wire window_complete = (cycle_count == 2'd2);

    // Output logic - active when window completes and exactly two 1's seen
    assign z = (state == B) && window_complete && (ones_count == 2'd2);

    // State transition logic
    always @(posedge clk) begin
        if (reset) state <= A;
        else state <= next_state;
    end

    // Cycle counter logic
    always @(posedge clk) begin
        if (reset || state == A) cycle_count <= 2'b00;
        else if (state == B) begin
            if (window_complete) cycle_count <= 2'b00;
            else cycle_count <= cycle_count + 1'b1;
        end
    end

    // Ones counter logic
    always @(posedge clk) begin
        if (reset || state == A) ones_count <= 2'b00;
        else if (state == B) begin
            if (window_complete) ones_count <= w;  // Start new window
            else ones_count <= ones_count + w;     // Continue counting
        end
    end

endmodule
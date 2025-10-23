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

    // State transition logic (combinational)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Window evaluation condition
    wire window_complete = (cycle_count == 2'd2);
    wire two_ones = (ones_count == 2'd2);

    // Output logic
    assign z = (state == B) && window_complete && two_ones;

    // State register
    always @(posedge clk) begin
        if (reset) state <= A;
        else state <= next_state;
    end

    // Cycle counter
    always @(posedge clk) begin
        if (reset || state == A) begin
            cycle_count <= 2'b00;
        end else if (state == B) begin
            cycle_count <= window_complete ? 2'd0 : (cycle_count + 1'b1);
        end
    end

    // Ones counter
    always @(posedge clk) begin
        if (reset || state == A) begin
            ones_count <= 2'b00;
        end else if (state == B) begin
            if (window_complete)
                ones_count <= w;  // Start new window
            else
                ones_count <= ones_count + w;
        end
    end

endmodule
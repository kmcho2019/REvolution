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
    reg [1:0] cycle_count;
    reg [2:0] w_pattern;

    // Next state logic (continuous assignment)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Counter logic (automatically wraps)
    wire [1:0] next_cycle_count = (state == B) ? 
                                 (cycle_count + 1'b1) : 2'b00;

    // Pattern storage logic
    wire [2:0] next_w_pattern = (state == B) ? 
                              {w_pattern[1:0], w} : 3'b000;

    // Pattern matching (exactly two 1's)
    wire pattern_match = (w_pattern == 3'b011) || 
                        (w_pattern == 3'b101) || 
                        (w_pattern == 3'b110);

    // Output logic - active at window boundary
    assign z = (state == B) && (cycle_count == 2'd0) && pattern_match;

    // Sequential elements
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_pattern <= 3'b000;
        end else begin
            state <= next_state;
            cycle_count <= next_cycle_count;
            w_pattern <= next_w_pattern;
        end
    end

endmodule
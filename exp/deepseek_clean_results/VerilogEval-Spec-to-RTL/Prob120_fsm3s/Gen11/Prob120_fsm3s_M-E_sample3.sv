module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // 4-bit shift register with parallel load capability
    reg [3:0] state;
    wire shift_en;
    wire [3:0] parallel_load;

    // State assignments (one-hot-like encoding)
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // Shift enable logic (when we should shift instead of parallel load)
    assign shift_en = (state == A && in) || 
                     (state == B && ~in) || 
                     (state == C && in) || 
                     (state == D && ~in);

    // Parallel load patterns for each state transition
    assign parallel_load = (state == A && ~in) ? A :
                          (state == B && in) ? B :
                          (state == C && ~in) ? A :
                          (state == D && in) ? B : 4'b0;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else if (shift_en)
            state <= {state[2:0], 1'b0};  // Shift left
        else
            state <= parallel_load;       // Parallel load
    end

    // Output is simply the MSB (state D)
    assign out = state[3];

endmodule
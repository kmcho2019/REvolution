module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State definitions for readability
localparam STRONG_NT = 2'b00;  // Strongly not-taken
localparam WEAK_NT   = 2'b01;  // Weakly not-taken (reset state)
localparam WEAK_T    = 2'b10;  // Weakly taken
localparam STRONG_T  = 2'b11;  // Strongly taken

reg [1:0] next_state;

// Optimized next state logic
always_comb begin
    if (areset) begin
        next_state = WEAK_NT;  // Async reset to weakly not-taken
    end
    else if (train_valid) begin
        if (train_taken) begin
            // Increment with saturation at STRONG_T
            next_state = (state == STRONG_T) ? STRONG_T : state + 1;
        end
        else begin
            // Decrement with saturation at STRONG_NT
            next_state = (state == STRONG_NT) ? STRONG_NT : state - 1;
        end
    end
    else begin
        next_state = state;  // Hold when not training
    end
end

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WEAK_NT;
    end else begin
        state <= next_state;
    end
end

endmodule
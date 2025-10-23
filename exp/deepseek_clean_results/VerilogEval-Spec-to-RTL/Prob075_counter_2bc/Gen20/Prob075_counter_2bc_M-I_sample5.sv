module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Gray-coded state definitions for minimal transitions
localparam STRONG_NT = 2'b00;  // Strongly not-taken
localparam WEAK_NT   = 2'b01;  // Weakly not-taken (reset state)
localparam WEAK_T    = 2'b11;  // Weakly taken
localparam STRONG_T  = 2'b10;  // Strongly taken

wire clk_gated = clk & (train_valid | areset);  // Clock gating

// Optimized next state logic with parallel arithmetic
always @(*) begin
    if (areset) begin
        state = WEAK_NT;
    end
    else if (train_valid) begin
        case ({train_taken, state})
            // Increment cases (with saturation)
            3'b1_00: state = WEAK_NT;   // STRONG_NT -> WEAK_NT
            3'b1_01: state = WEAK_T;    // WEAK_NT -> WEAK_T
            3'b1_11: state = STRONG_T;  // WEAK_T -> STRONG_T
            3'b1_10: state = STRONG_T;  // STRONG_T (saturated)
            
            // Decrement cases (with saturation)
            3'b0_00: state = STRONG_NT; // STRONG_NT (saturated)
            3'b0_01: state = STRONG_NT; // WEAK_NT -> STRONG_NT
            3'b0_11: state = WEAK_NT;   // WEAK_T -> WEAK_NT
            3'b0_10: state = WEAK_T;    // STRONG_T -> WEAK_T
            
            default: state = state;
        endcase
    end
    // else hold state (implicit)
end

// Sequential state register with clock gating
always @(posedge clk_gated or posedge areset) begin
    if (areset) begin
        state <= WEAK_NT;
    end
    else begin
        state <= state;  // Self-assignment for clock gating
    end
end

endmodule
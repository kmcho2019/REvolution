module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// One-hot encoded states
localparam HOLD  = 2'b01;
localparam SHIFT = 2'b10;
localparam LOAD  = 2'b00; // Special case - overrides others

reg [1:0] state, next_state;

// Next state logic
always @(*) begin
    case (state)
        HOLD:  next_state = E ? SHIFT : HOLD;
        SHIFT: next_state = E ? SHIFT : HOLD;
        default: next_state = HOLD;
    endcase
    
    // Load has highest priority
    if (L) next_state = LOAD;
end

// Output logic
always @(posedge clk) begin
    case (next_state)
        LOAD:  Q <= R;
        SHIFT: Q <= w;
        HOLD:  Q <= Q;  // Explicit hold for clarity
    endcase
end

// State register
always @(posedge clk) begin
    state <= next_state;
end

endmodule
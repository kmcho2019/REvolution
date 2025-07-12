module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// One-hot state encoding
localparam [2:0] HOLD  = 3'b001;
localparam [2:0] LOAD  = 3'b010;
localparam [2:0] SHIFT = 3'b100;

reg [2:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        HOLD: next_state = L ? LOAD : (E ? SHIFT : HOLD);
        LOAD: next_state = HOLD;
        SHIFT: next_state = L ? LOAD : (E ? SHIFT : HOLD);
        default: next_state = HOLD;
    endcase
end

// Output logic
always @(posedge clk) begin
    state <= next_state;
    case (next_state)
        LOAD: Q <= R;
        SHIFT: Q <= w;
        HOLD: Q <= Q;  // Explicit hold - could be optimized out
        default: Q <= Q;
    endcase
end

// Initial state
initial begin
    state = HOLD;
    Q = 1'b0;
end

endmodule
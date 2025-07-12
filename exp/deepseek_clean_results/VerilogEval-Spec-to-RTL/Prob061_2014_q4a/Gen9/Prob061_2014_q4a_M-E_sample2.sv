module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Define states
localparam HOLD  = 2'b00;
localparam SHIFT = 2'b01;
localparam LOAD  = 2'b10;

reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        HOLD:  next_state = L ? LOAD : (E ? SHIFT : HOLD);
        SHIFT: next_state = L ? LOAD : (E ? SHIFT : HOLD);
        LOAD:  next_state = L ? LOAD : (E ? SHIFT : HOLD);
        default: next_state = HOLD;
    endcase
end

// Data path logic
always @(posedge clk) begin
    state <= next_state;
    
    case (next_state)
        LOAD:  Q <= R;
        SHIFT: Q <= w;
        HOLD: Q <= Q;  // Explicit hold
        default: Q <= Q;
    endcase
end

endmodule
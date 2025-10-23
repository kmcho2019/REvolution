module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// State encoding
localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam LOAD = 2'b10;

reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        IDLE: next_state = L ? LOAD : (E ? SHIFT : IDLE);
        SHIFT: next_state = L ? LOAD : (E ? SHIFT : IDLE);
        LOAD: next_state = E ? SHIFT : IDLE;
        default: next_state = IDLE;
    endcase
end

// Data path logic
always @(posedge clk) begin
    state <= next_state;
    
    case (next_state)
        LOAD: Q <= R;
        SHIFT: Q <= w;
        IDLE: Q <= Q;  // Explicit hold
        default: Q <= Q;
    endcase
end

endmodule
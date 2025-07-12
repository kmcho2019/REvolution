module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// State encoding
localparam HOLD  = 2'b00;
localparam LOAD  = 2'b01;
localparam SHIFT = 2'b10;

reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        HOLD:  next_state = L ? LOAD : (E ? SHIFT : HOLD);
        LOAD:  next_state = HOLD;
        SHIFT: next_state = L ? LOAD : (E ? SHIFT : HOLD);
        default: next_state = HOLD;
    endcase
end

// State register
always @(posedge clk) begin
    state <= next_state;
end

// Data path
always @(posedge clk) begin
    case (next_state)
        LOAD:  Q <= R;
        SHIFT: Q <= w;
        HOLD:  Q <= Q;
        default: Q <= Q;
    endcase
end

endmodule
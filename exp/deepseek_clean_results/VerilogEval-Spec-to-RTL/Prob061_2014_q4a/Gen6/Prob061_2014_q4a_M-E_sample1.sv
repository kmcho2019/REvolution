module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// State encoding
localparam HOLD = 2'b00;
localparam SHIFT = 2'b01;
localparam LOAD = 2'b10;

reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        HOLD:   next_state = L ? LOAD : (E ? SHIFT : HOLD);
        SHIFT:  next_state = L ? LOAD : (E ? SHIFT : HOLD);
        LOAD:   next_state = E ? SHIFT : HOLD;
        default: next_state = HOLD;
    endcase
end

// Output logic
always @(*) begin
    case (state)
        HOLD:   Q = Q;
        SHIFT:  Q = w;
        LOAD:   Q = R;
        default: Q = Q;
    endcase
end

// State register
always @(posedge clk) begin
    state <= next_state;
    // Output register for better timing
    case (next_state)
        HOLD:   Q <= Q;
        SHIFT:  Q <= w;
        LOAD:   Q <= R;
        default: Q <= Q;
    endcase
end

endmodule
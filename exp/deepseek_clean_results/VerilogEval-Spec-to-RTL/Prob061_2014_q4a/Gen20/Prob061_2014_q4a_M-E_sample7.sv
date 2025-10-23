module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

// State encoding
localparam HOLD  = 2'b00;
localparam SHIFT = 2'b01;
localparam LOAD  = 2'b10;

reg [1:0] state, next_state;
reg Q_reg;
wire gated_clk;

// State transition logic
always @(*) begin
    case (state)
        HOLD:  next_state = L ? LOAD : (E ? SHIFT : HOLD);
        SHIFT: next_state = L ? LOAD : (E ? SHIFT : HOLD);
        LOAD:  next_state = L ? LOAD : (E ? SHIFT : HOLD);
        default: next_state = HOLD;
    endcase
end

// Clock gating for power optimization
assign gated_clk = clk & (state != HOLD);

// Data path mux
wire next_Q = (state == LOAD) ? R : 
             ((state == SHIFT) ? w : Q_reg);

// State and data registers
always @(posedge gated_clk) begin
    state <= next_state;
    Q_reg <= next_Q;
end

assign Q = Q_reg;

endmodule
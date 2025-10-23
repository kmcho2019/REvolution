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

reg [1:0] state;

always @(posedge clk) begin
    // State transition logic
    case (state)
        HOLD:   state <= L ? LOAD : (E ? SHIFT : HOLD);
        SHIFT:  state <= L ? LOAD : (E ? SHIFT : HOLD);
        LOAD:   state <= E ? SHIFT : HOLD;
        default: state <= HOLD;
    endcase

    // Output logic
    case (state)
        HOLD:   Q <= Q;
        SHIFT:  Q <= w;
        LOAD:   Q <= R;
        default: Q <= Q;
    endcase
end

// Initialize state
initial begin
    state = HOLD;
    Q = 1'b0;
end

endmodule
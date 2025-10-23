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
localparam SHIFT = 2'b01;
localparam LOAD  = 2'b10;
localparam RESET = 2'b11;

reg [1:0] state;

always @(posedge clk) begin
    case (state)
        HOLD:  Q <= Q;          // Maintain current value
        SHIFT: Q <= w;           // Shift in from previous stage
        LOAD:  Q <= R;           // Load new value
        RESET: Q <= 1'b0;        // Reset (unused in this design)
    endcase
end

always @(posedge clk) begin
    case (state)
        HOLD:  state <= L ? LOAD : (E ? SHIFT : HOLD);
        SHIFT: state <= L ? LOAD : (E ? SHIFT : HOLD);
        LOAD:  state <= E ? SHIFT : HOLD;
        RESET: state <= HOLD;
    endcase
end

// Initialize to HOLD state
initial begin
    state = HOLD;
    Q = 1'b0;
end

endmodule
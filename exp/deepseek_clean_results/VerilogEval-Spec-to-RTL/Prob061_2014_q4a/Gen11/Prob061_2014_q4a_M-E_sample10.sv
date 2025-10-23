module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// State definitions
localparam HOLD = 2'b00;
localparam SHIFT = 2'b01;
localparam LOAD = 2'b10;

reg [1:0] state;

// Next state logic
always @(*) begin
    case (state)
        HOLD: state = L ? LOAD : (E ? SHIFT : HOLD);
        SHIFT: state = L ? LOAD : (E ? SHIFT : HOLD);
        LOAD: state = L ? LOAD : (E ? SHIFT : HOLD);
        default: state = HOLD;
    endcase
end

// Output logic
always @(posedge clk) begin
    case (state)
        HOLD: Q <= Q;
        SHIFT: Q <= w;
        LOAD: Q <= R;
        default: Q <= Q;
    endcase
end

endmodule
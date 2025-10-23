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
    case (state)
        HOLD: Q <= Q;
        SHIFT: Q <= w;
        LOAD: Q <= R;
        default: Q <= Q;
    endcase
end

always @(*) begin
    case ({L, E})
        2'b10: state = LOAD;
        2'b01: state = SHIFT;
        default: state = HOLD;
    endcase
end

endmodule
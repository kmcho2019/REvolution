module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// One-hot encoded states
localparam [2:0] HOLD  = 3'b001;
localparam [2:0] SHIFT = 3'b010;
localparam [2:0] LOAD  = 3'b100;

reg [2:0] state;

always @(posedge clk) begin
    // State transition logic
    case (1'b1)
        L:       state <= LOAD;
        E && !L: state <= SHIFT;
        default: state <= HOLD;
    endcase

    // Output logic
    case (state)
        LOAD:  Q <= R;
        SHIFT: Q <= w;
        HOLD:  Q <= Q;
        default: Q <= Q;
    endcase
end

endmodule
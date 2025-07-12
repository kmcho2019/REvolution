module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;
    wire clk_en;

    // Determine if register should update (load or a valid rotate direction)
    assign clk_en = load | (ena == 2'b01) | (ena == 2'b10);

    // Combinational next state logic with minimal ternary mux
    always @(*) begin
        next_q = load           ? data                        :
                 (ena == 2'b10)  ? {q[98:0], q[99]}            : // rotate left
                 (ena == 2'b01)  ? {q[0], q[99:1]}             : // rotate right
                                   q;                            // hold current
    end

    // Register update with inferred clock enable to reduce toggling/power
    always @(posedge clk) begin
        if (clk_en)
            q <= next_q;
    end

endmodule
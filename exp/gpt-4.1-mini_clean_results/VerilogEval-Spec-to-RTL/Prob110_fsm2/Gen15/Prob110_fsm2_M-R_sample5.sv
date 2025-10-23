module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // One-hot state encoding
    localparam OFF = 2'b01;
    localparam ON  = 2'b10;

    reg [1:0] state;

    // Next state logic as continuous assignment
    wire [1:0] next_state;

    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                        (state == ON)  ? (k ? OFF : ON)  :
                        OFF;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output is 1 when in ON state (one-hot bit 1)
    assign out = state[1];

endmodule
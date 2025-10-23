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

    reg [1:0] state, next_state;

    // Synchronous reset state register
    always @(posedge clk) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF; // safe default
        endcase
    end

    // Output is high when in ON state (one-hot)
    assign out = state[1];

endmodule
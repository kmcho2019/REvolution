module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // One-hot encoding for states
    localparam OFF = 2'b01;
    localparam ON  = 2'b10;

    reg [1:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            OFF: next_state = j ? ON : OFF;
            ON : next_state = k ? OFF : ON;
            default: next_state = OFF; // safe default
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic: out=1 when state=ON (2'b10), else 0
    assign out = state[1];

endmodule
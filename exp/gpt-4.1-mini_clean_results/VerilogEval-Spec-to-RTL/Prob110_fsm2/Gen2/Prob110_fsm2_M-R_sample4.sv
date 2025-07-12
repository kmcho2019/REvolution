module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // One-hot state encoding: [1:0] = {ON, OFF}
    localparam OFF = 2'b01;
    localparam ON  = 2'b10;

    reg [1:0] state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state logic using continuous assign style (implemented as combinational always for clarity)
    // Using a combinational assignment style in a separate block would be complex; instead, implement combinational next_state
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Output is 1 when ON state is active (one-hot)
    assign out = state[1];

endmodule
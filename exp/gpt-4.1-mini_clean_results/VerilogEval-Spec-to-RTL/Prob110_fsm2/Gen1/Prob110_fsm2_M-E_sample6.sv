module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // One-hot encoded states
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

    // Next state logic using one-hot encoding
    always @(*) begin
        case(state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Moore output logic: output = 1 if ON state active
    always @(*) begin
        out = state[1];  // ON state bit
    end

endmodule
module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // One-hot encoding for states
    localparam OFF = 2'b01;
    localparam ON  = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output is 1 when in ON state, else 0
    assign out = (state == ON);

endmodule
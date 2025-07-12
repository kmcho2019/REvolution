module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    reg next_state;

    // Asynchronous active-high reset and synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Combinational next-state logic using case statement for clarity and safety
    always @(*) begin
        case (state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF; // safe fallback
        endcase
    end

    // Moore output logic as a continuous assignment for minimal latency and simple synthesis
    assign out = (state == ON);

endmodule
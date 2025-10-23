module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// State encoding: 1-bit for minimal area and power
localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state, next_state;

// Combinational next-state logic with case statement for clarity and synthesis friendliness
always @(*) begin
    case (state)
        OFF: next_state = j ? ON : OFF;
        ON:  next_state = k ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// Sequential state register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

// Combinational Moore output: output depends only on current state
assign out = (state == ON);

endmodule
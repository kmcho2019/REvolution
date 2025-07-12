module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// State encoding
localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state;
reg next_state;

// Combinational logic to compute next_state based on current state and inputs
always @(*) begin
    case (state)
        OFF: next_state = j ? ON : OFF;
        ON:  next_state = k ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// Sequential logic: state register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

// Moore output purely combinational, depends only on current state
assign out = (state == ON);

endmodule
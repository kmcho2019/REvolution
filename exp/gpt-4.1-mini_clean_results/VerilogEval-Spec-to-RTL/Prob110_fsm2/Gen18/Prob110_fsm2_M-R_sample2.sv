module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state;

// State encoding
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Next state logic as combinational continuous assignment
wire next_state = (state == OFF) ? (j ? ON : OFF) :
                  (state == ON)  ? (k ? OFF : ON) :
                                   OFF;

// Output logic (Moore output) directly from state
assign out = (state == ON) ? 1'b1 : 1'b0;

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

endmodule
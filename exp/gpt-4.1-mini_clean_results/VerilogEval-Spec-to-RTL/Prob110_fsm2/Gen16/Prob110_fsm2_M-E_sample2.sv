module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state;

// Next state logic as combinational signals
wire next_state;
assign next_state = (state == OFF) ? (j ? ON : OFF)
                                 : (k ? OFF : ON);

// Output logic purely combinational from current state (Moore output)
assign out = (state == ON) ? 1'b1 : 1'b0;

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

endmodule
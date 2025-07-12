module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire j,
    input  wire k,
    output wire out
);

// State encoding
localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state;
wire next_state;

// Next-state logic (combinational, continuous assignment)
assign next_state = (state == OFF) ? (j ? ON : OFF) :
                    (state == ON)  ? (k ? OFF : ON) :
                    OFF; // default safe fallback

// Output logic (Moore machine): output depends only on current state
assign out = (state == ON);

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

endmodule
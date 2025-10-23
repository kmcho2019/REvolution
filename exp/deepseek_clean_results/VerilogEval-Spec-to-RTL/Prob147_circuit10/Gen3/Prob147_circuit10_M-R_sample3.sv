module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

wire clk_posedge = clk & ~$past(clk);
wire toggle_condition = a & b & clk_posedge;
reg state_reg = 0;

assign state = state_reg;
assign state_reg = toggle_condition ? ~state : state;
assign q = a ? ~(state ^ b) : (state ^ b);

// Clock edge detection
reg past_clk = 0;
always @* past_clk <= clk;

endmodule
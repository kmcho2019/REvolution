module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// Simplified next state logic to reduce switching activity
always @(*) begin
    if (r[0]) next_state = 2'b01;
    else if (r[1]) next_state = 2'b10;
    else if (r[2]) next_state = 2'b11;
    else next_state = 2'b00;
end

// Use of non-blocking assignment for state update to reduce potential race conditions
always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else state <= next_state;
end

// Maintaining continuous assignment for g to minimize area and power
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule
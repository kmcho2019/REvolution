module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;

// Define next state logic using assign
wire [1:0] next_state;
assign next_state = 
    (state == 2'b00 && r[0]) ? 2'b01 :
    (state == 2'b00 && !r[0] && r[1]) ? 2'b10 :
    (state == 2'b00 && !r[0] && !r[1] && r[2]) ? 2'b11 :
    (state == 2'b01 && r[0]) ? 2'b01 :
    (state == 2'b01 && !r[0]) ? 2'b00 :
    (state == 2'b10 && r[1]) ? 2'b10 :
    (state == 2'b10 && !r[1]) ? 2'b00 :
    (state == 2'b11 && r[2]) ? 2'b11 :
    (state == 2'b11 && !r[2]) ? 2'b00 : state;

// Sequential logic for state update
always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else state <= next_state;
end

// Output logic using assign
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule
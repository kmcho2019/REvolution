module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// State encoding: A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
reg [1:0] state;
reg [1:0] next_state;

// Priority encoder
wire [1:0] priority_code;
assign priority_code = (r[0]? 2'b01 : (r[1]? 2'b10 : (r[2]? 2'b11 : 2'b00)));

// Next state logic
assign next_state = (
    (state == 2'b00 && r[0])? 2'b01 :
    (state == 2'b00 &&!r[0] && r[1])? 2'b10 :
    (state == 2'b00 &&!r[0] &&!r[1] && r[2])? 2'b11 :
    (state == 2'b01 && r[0])? 2'b01 :
    (state == 2'b01 &&!r[0])? 2'b00 :
    (state == 2'b10 && r[1])? 2'b10 :
    (state == 2'b10 &&!r[1])? 2'b00 :
    (state == 2'b11 && r[2])? 2'b11 :
    (state == 2'b11 &&!r[2])? 2'b00 :
    2'b00
);

// Output logic
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

// State register
always @(posedge clk)
begin
    if (~resetn)
        state <= 2'b00;  // Reset to state A
    else
        state <= next_state;
end

endmodule
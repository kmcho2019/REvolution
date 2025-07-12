module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

always @ (*) begin
    if (y == 3'b000) 
        next_state = x? 3'b001 : 3'b000;
    else if (y == 3'b001) 
        next_state = x? 3'b100 : 3'b001;
    else if (y == 3'b010) 
        next_state = x? 3'b001 : 3'b010;
    else if (y == 3'b011) 
        next_state = x? 3'b010 : 3'b001;
    else if (y == 3'b100) 
        next_state = x? 3'b100 : 3'b011;
    else 
        next_state = 3'b000;
end

always @ (posedge clk) begin
    current_state <= next_state;
end

always @ (*) begin
    if (y == 3'b011 || y == 3'b100) 
        z = 1'b1;
    else 
        z = 1'b0;
end

assign Y0 = next_state[0];

endmodule
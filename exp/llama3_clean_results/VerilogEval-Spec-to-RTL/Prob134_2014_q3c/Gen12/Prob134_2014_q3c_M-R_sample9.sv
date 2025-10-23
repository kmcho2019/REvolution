module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output reg Y0,
    output reg z
);

reg [2:0] current_state;

// Sequential logic
always @ (posedge clk) begin
    current_state <= (x == 1'b0) ? 
        (y == 3'b000) ? 3'b000 :
        (y == 3'b001) ? 3'b001 :
        (y == 3'b010) ? 3'b010 :
        (y == 3'b011) ? 3'b001 :
        (y == 3'b100) ? 3'b011 : 3'b000 :
        (y == 3'b000) ? 3'b001 :
        (y == 3'b001) ? 3'b100 :
        (y == 3'b010) ? 3'b001 :
        (y == 3'b011) ? 3'b010 :
        (y == 3'b100) ? 3'b100 : 3'b000;
end

// Combinational logic for z and Y0
assign z = (y == 3'b011) || (y == 3'b100);
assign Y0 = current_state[0];

endmodule
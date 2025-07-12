module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] state;

// Initialize state
initial begin
    state = 3'b000;
end

// Sequential logic to update current state
always @(posedge clk) begin
    state <= y;
end

// Combinational logic to determine next state and output z
wire [2:0] nextState;
assign nextState = (y == 3'b000 &&!x)? 3'b000 :
                   (y == 3'b000 && x) ? 3'b001 :
                   (y == 3'b001 &&!x)? 3'b001 :
                   (y == 3'b001 && x) ? 3'b100 :
                   (y == 3'b010 &&!x)? 3'b010 :
                   (y == 3'b010 && x) ? 3'b001 :
                   (y == 3'b011 &&!x)? 3'b001 :
                   (y == 3'b011 && x) ? 3'b010 :
                   (y == 3'b100 &&!x)? 3'b011 :
                   (y == 3'b100 && x) ? 3'b100 :
                   3'b000;

assign Y0 = nextState[0];

assign z = (y == 3'b011 || y == 3'b100);

endmodule
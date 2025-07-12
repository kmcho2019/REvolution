module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// Next state logic using assign
assign next_y = (y == 3'b000)? (x? 3'b001 : 3'b000) :
                (y == 3'b001)? (x? 3'b100 : 3'b001) :
                (y == 3'b010)? (x? 3'b001 : 3'b010) :
                (y == 3'b011)? (x? 3'b010 : 3'b001) :
                (y == 3'b100)? (x? 3'b100 : 3'b011) :
                3'b000;

// Output logic using assign
assign z = (y == 3'b011) || (y == 3'b100)? 1'b1 : 1'b0;

// State register with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        y <= next_y;
    end
end

endmodule
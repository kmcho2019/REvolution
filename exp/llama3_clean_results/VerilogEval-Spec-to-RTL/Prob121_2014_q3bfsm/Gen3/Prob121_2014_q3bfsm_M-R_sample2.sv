module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // Current state
reg [2:0] next_y; // Next state

// Next state logic using continuous assignment
assign next_y = (y == 3'b000 && !x) ? 3'b000 :
                 (y == 3'b000 && x) ? 3'b001 :
                 (y == 3'b001 && !x) ? 3'b001 :
                 (y == 3'b001 && x) ? 3'b100 :
                 (y == 3'b010 && !x) ? 3'b010 :
                 (y == 3'b010 && x) ? 3'b001 :
                 (y == 3'b011 && !x) ? 3'b001 :
                 (y == 3'b011 && x) ? 3'b010 :
                 (y == 3'b100 && !x) ? 3'b011 :
                 (y == 3'b100 && x) ? 3'b100 :
                 3'b000; // Default to 000 for all other cases

// Output logic using continuous assignment
assign z = (y == 3'b011 || y == 3'b100) ? 1 : 0;

// Sequential logic to update the state
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        y <= next_y;
    end
end

endmodule
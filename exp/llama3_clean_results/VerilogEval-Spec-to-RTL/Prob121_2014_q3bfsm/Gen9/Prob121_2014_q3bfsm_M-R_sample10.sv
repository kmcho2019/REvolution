module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// Next state logic using assign for combinational logic
assign next_y = (y == 3'b000) ? (x ? 3'b001 : 3'b000) :
                (y == 3'b001) ? (x ? 3'b100 : 3'b001) :
                (y == 3'b010) ? (x ? 3'b001 : 3'b010) :
                (y == 3'b011) ? (x ? 3'b010 : 3'b001) :
                (y == 3'b100) ? (x ? 3'b100 : 3'b011) :
                3'b000; // Default next state

// Output logic using assign for combinational logic
assign z = (y == 3'b011) || (y == 3'b100);

// Sequential logic for state register update with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Synchronous active high reset
    end else if (y != next_y) begin // Only update state if it changes
        y <= next_y;
    end
end

endmodule
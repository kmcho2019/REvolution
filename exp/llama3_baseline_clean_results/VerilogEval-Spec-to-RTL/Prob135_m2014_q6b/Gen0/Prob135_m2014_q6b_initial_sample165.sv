module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
wire y1_next;

assign y1_next = (y == 3'b000 && w) || (y == 3'b001 && w) || (y == 3'b010 && w) || (y == 3'b011 && ~w) || (y == 3'b101 && w) || (y == 3'b100 && ~w);

// Output Y1 is the current state y[1]
assign Y1 = y[1];

// For simulation purposes, we can also include a flip-flop to store the next state
reg [2:0] y_reg;
always @(posedge w) begin
    y_reg <= {y1_next, y[1:0]};
end

endmodule
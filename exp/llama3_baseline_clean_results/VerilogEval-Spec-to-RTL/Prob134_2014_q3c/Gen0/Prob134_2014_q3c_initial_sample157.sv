module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] Y; // Current state
reg [2:0] next_Y; // Next state

// Combinational logic for next state
always @(*) begin
    case (y)
        3'b000: next_Y = x ? 3'b001 : 3'b000;
        3'b001: next_Y = x ? 3'b100 : 3'b001;
        3'b010: next_Y = x ? 3'b001 : 3'b010;
        3'b011: next_Y = x ? 3'b010 : 3'b001;
        3'b100: next_Y = x ? 3'b100 : 3'b011;
        default: next_Y = 3'b000; // Default state
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    Y <= next_Y;
end

// Output logic
assign Y0 = next_Y[0];
assign z = (y == 3'b011 && x == 1) || (y == 3'b100 && x == 1) || (y == 3'b100 && x == 0);

endmodule
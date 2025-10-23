module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Simplified combinational logic for next state
always @ (*) begin
    case (y)
        3'b000: next_state = x ? 3'b001 : 3'b000;
        3'b001, 3'b010: next_state = x ? (y == 3'b001 ? 3'b100 : 3'b001) : y;
        3'b011: next_state = x ? 3'b010 : 3'b001;
        3'b100: next_state = x ? 3'b100 : 3'b011;
        default: next_state = 3'b000;
    endcase
end

// Sequential logic remains the same
always @ (posedge clk) begin
    current_state <= next_state;
end

// Output logic for z remains the same
always @ (*) begin
    z = (y == 3'b011 || y == 3'b100);
end

assign Y0 = next_state[0];

endmodule
module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Initialize state to 3'b000
always @ (posedge clk) begin
    current_state <= next_state;
end

// Combinational logic for next state
always @ (*) begin
    case ({y, x})
        4'b0000: next_state = 3'b000;
        4'b0001: next_state = 3'b001;
        4'b0010: next_state = 3'b001;
        4'b0011: next_state = 3'b100;
        4'b0100: next_state = 3'b010;
        4'b0101: next_state = 3'b001;
        4'b0110: next_state = 3'b001;
        4'b0111: next_state = 3'b010;
        4'b1000: next_state = 3'b011;
        4'b1001: next_state = 3'b100;
        default: next_state = 3'b000;
    endcase
end

// Output logic for z
assign z = (y == 3'b011 || y == 3'b100);

// Assign Y0
assign Y0 = next_state[0];

endmodule
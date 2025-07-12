module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
wire [2:0] next_state;

always @(*) begin
    case ({current_state, y})
        6'b000_000: next_state = x ? 3'b001 : 3'b000;
        6'b001_000: next_state = x ? 3'b100 : 3'b001;
        6'b010_000: next_state = x ? 3'b001 : 3'b010;
        6'b011_000: next_state = x ? 3'b010 : 3'b001;
        6'b100_000: next_state = x ? 3'b100 : 3'b011;
        6'b000_001: next_state = x ? 3'b001 : 3'b000;
        6'b001_001: next_state = x ? 3'b100 : 3'b001;
        6'b010_001: next_state = x ? 3'b001 : 3'b010;
        6'b011_001: next_state = x ? 3'b010 : 3'b001;
        6'b100_001: next_state = x ? 3'b100 : 3'b011;
        6'b000_010: next_state = x ? 3'b001 : 3'b000;
        6'b001_010: next_state = x ? 3'b100 : 3'b001;
        6'b010_010: next_state = x ? 3'b001 : 3'b010;
        6'b011_010: next_state = x ? 3'b010 : 3'b001;
        6'b100_010: next_state = x ? 3'b100 : 3'b011;
        6'b000_011: next_state = x ? 3'b001 : 3'b000;
        6'b001_011: next_state = x ? 3'b100 : 3'b001;
        6'b010_011: next_state = x ? 3'b001 : 3'b010;
        6'b011_011: next_state = x ? 3'b010 : 3'b001;
        6'b100_011: next_state = x ? 3'b100 : 3'b011;
        6'b000_100: next_state = x ? 3'b001 : 3'b000;
        6'b001_100: next_state = x ? 3'b100 : 3'b001;
        6'b010_100: next_state = x ? 3'b001 : 3'b010;
        6'b011_100: next_state = x ? 3'b010 : 3'b001;
        6'b100_100: next_state = x ? 3'b100 : 3'b011;
        6'b000_101: next_state = x ? 3'b001 : 3'b000;
        6'b001_101: next_state = x ? 3'b100 : 3'b001;
        6'b010_101: next_state = x ? 3'b001 : 3'b010;
        6'b011_101: next_state = x ? 3'b010 : 3'b001;
        6'b100_101: next_state = x ? 3'b100 : 3'b011;
        6'b000_110: next_state = x ? 3'b001 : 3'b000;
        6'b001_110: next_state = x ? 3'b100 : 3'b001;
        6'b010_110: next_state = x ? 3'b001 : 3'b010;
        6'b011_110: next_state = x ? 3'b010 : 3'b001;
        6'b100_110: next_state = x ? 3'b100 : 3'b011;
        6'b000_111: next_state = x ? 3'b001 : 3'b000;
        6'b001_111: next_state = x ? 3'b100 : 3'b001;
        6'b010_111: next_state = x ? 3'b001 : 3'b010;
        6'b011_111: next_state = x ? 3'b010 : 3'b001;
        6'b100_111: next_state = x ? 3'b100 : 3'b011;
        default: next_state = 3'b000;
    endcase
end

always @(posedge clk) begin
    current_state <= next_state;
end

assign Y0 = next_state[0];
assign z = (current_state == 3'b011) || (current_state == 3'b100);

endmodule
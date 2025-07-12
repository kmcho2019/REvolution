module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;
reg [2:0] next_state;

always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else state <= next_state;
end

always @(*) begin
    if (r[0]) next_state = 3'b001;
    else if (r[1]) next_state = 3'b010;
    else if (r[2]) next_state = 3'b011;
    else next_state = 3'b000;
end

always @(*) begin
    case (state)
        3'b001: g = 3'b100;
        3'b010: g = 3'b010;
        3'b011: g = 3'b001;
        default: g = 3'b000;
    endcase
end

endmodule
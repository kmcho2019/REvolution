module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;
reg [2:0] next_state;

always @(*) begin
    case (state)
        3'b000: begin
            if (r[0]) next_state = 3'b001;
            else if (r[1]) next_state = 3'b010;
            else if (r[2]) next_state = 3'b011;
            else next_state = 3'b000;
        end
        3'b001: next_state = r[0] ? 3'b001 : 3'b000;
        3'b010: next_state = r[1] ? 3'b010 : 3'b000;
        3'b011: next_state = r[2] ? 3'b011 : 3'b000;
        default: next_state = 3'b000;
    endcase
end

always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else state <= next_state;
end

assign g[0] = state == 3'b001;
assign g[1] = state == 3'b010;
assign g[2] = state == 3'b011;

endmodule
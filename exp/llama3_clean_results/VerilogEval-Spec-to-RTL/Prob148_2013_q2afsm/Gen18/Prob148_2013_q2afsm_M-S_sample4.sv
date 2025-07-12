module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;
reg [2:0] next_state;

// State table
always @(*) begin
    case (state)
        3'b000: next_state = (r[0]) ? 3'b001 : (r[1]) ? 3'b010 : (r[2]) ? 3'b011 : 3'b000;
        3'b001: next_state = (r[0]) ? 3'b001 : 3'b000;
        3'b010: next_state = (r[1]) ? 3'b010 : 3'b000;
        3'b011: next_state = 3'b000; // directly return to state A when r[2] is low
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else state <= next_state;
end

// Output assignments
assign g[0] = (state == 3'b001);
assign g[1] = (state == 3'b010);
assign g[2] = (state == 3'b011);

endmodule
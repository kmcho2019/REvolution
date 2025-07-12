`define A 3'b000
`define B 3'b001
`define C 3'b010
`define D 3'b011
`define E 3'b100
`define F 3'b101

module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

always @(*) begin
    case (current_state)
        `A: next_state = (w) ? `B : `A;
        `B: next_state = (w) ? `C : `D;
        `C: next_state = (w) ? `E : `D;
        `D: next_state = (w) ? `F : `A;
        `E: next_state = (w) ? `E : `D;
        `F: next_state = (w) ? `C : `D;
        default: next_state = `A;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= `A;
    end else begin
        current_state <= next_state;
    end
end

assign z = (current_state == `E) || (current_state == `F);

endmodule
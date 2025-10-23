`define A 6'b000001
`define B 6'b000010
`define C 6'b000100
`define D 6'b001000
`define E 6'b010000
`define F 6'b100000

module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [5:0] current_state;
reg [5:0] next_state;
assign z = (current_state == `E) || (current_state == `F);

always @(*) begin
    case(current_state)
        `A: next_state = w? `A : `B;
        `B: next_state = w? `D : `C;
        `C: next_state = w? `D : `E;
        `D: next_state = w? `A : `F;
        `E: next_state = w? `D : `E;
        `F: next_state = w? `D : `C;
        default: next_state = `A;
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= `A;
    end else begin
        current_state <= next_state;
    end
end

endmodule
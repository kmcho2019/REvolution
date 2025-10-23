`define A 4'b0000
`define B 4'b0001
`define C 4'b0010
`define D 4'b0011
`define E 4'b0100
`define F 4'b0101

module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

reg [3:0] state;
reg [3:0] next_state;

always @(*) begin
    case (state)
        `A: next_state = w ? `A : `B;
        `B: next_state = w ? `D : `C;
        `C: next_state = w ? `D : `E;
        `D: next_state = w ? `A : `F;
        `E: next_state = w ? `D : `E;
        `F: next_state = w ? `D : `C;
        default: next_state = `A;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= `A;
        z <= 0;
    end else begin
        state <= next_state;
        case (next_state)
            `E, `F: z <= 1;
            default: z <= 0;
        endcase
    end
end

endmodule
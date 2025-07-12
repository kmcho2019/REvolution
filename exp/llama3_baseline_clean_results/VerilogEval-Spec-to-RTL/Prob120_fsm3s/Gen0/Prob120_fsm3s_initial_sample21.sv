`define A 2'b00
`define B 2'b01
`define C 2'b10
`define D 2'b11

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);
reg [1:0] current_state, next_state;

always @(posedge clk) begin
    if(reset) begin
        current_state <= `A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        `A: if(~in) next_state = `A; else next_state = `B;
        `B: if(~in) next_state = `C; else next_state = `B;
        `C: if(~in) next_state = `A; else next_state = `D;
        `D: if(~in) next_state = `C; else next_state = `B;
        default: next_state = `A;
    endcase
end

always @(*) begin
    case(current_state)
        `A: out = 1'b0;
        `B: out = 1'b0;
        `C: out = 1'b0;
        `D: out = 1'b1;
        default: out = 1'b0;
    endcase
end
endmodule
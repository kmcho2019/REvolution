`define STATE_A 2'b00
`define STATE_B 2'b01
`define STATE_C 2'b10
`define STATE_D 2'b11

module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case(state)
        `STATE_A: begin
            if (~in) next_state = `STATE_A;
            else next_state = `STATE_B;
        end
        `STATE_B: begin
            if (~in) next_state = `STATE_C;
            else next_state = `STATE_B;
        end
        `STATE_C: begin
            if (~in) next_state = `STATE_A;
            else next_state = `STATE_D;
        end
        `STATE_D: begin
            if (~in) next_state = `STATE_C;
            else next_state = `STATE_B;
        end
        default: next_state = `STATE_A;
    endcase
end

always @(posedge clk) begin
    if (reset) state <= `STATE_A;
    else state <= next_state;
end

always @(*) begin
    case(state)
        `STATE_A: out = 1'b0;
        `STATE_B: out = 1'b0;
        `STATE_C: out = 1'b0;
        `STATE_D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule
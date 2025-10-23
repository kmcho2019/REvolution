`define STATE_A 4'b0000
`define STATE_B 4'b0001
`define STATE_C 4'b0010
`define STATE_D 4'b0011
`define STATE_E 4'b0100
`define STATE_F 4'b0101
`define STATE_G 4'b0110

module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [3:0] current_state, next_state;
reg [1:0] x_seq;
reg [1:0] y_timer;

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= `STATE_A;
        x_seq <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        current_state <= next_state;
        x_seq <= (current_state == `STATE_C) ? {x_seq[0], x} : 0;
        y_timer <= (current_state == `STATE_D) ? (y_timer + 1) : 0;
        f <= (current_state == `STATE_B) ? 1 : 0;
        g <= (current_state == `STATE_D || current_state == `STATE_E) ? 1 : 0;
    end
end

always @(*) begin
    case(current_state)
        `STATE_A: next_state = (resetn) ? `STATE_B : `STATE_A;
        `STATE_B: next_state = `STATE_C;
        `STATE_C: next_state = ({x_seq[1], x_seq[0]} == 2'b101) ? `STATE_D : `STATE_C;
        `STATE_D: next_state = (y || y_timer == 2) ? (y ? `STATE_E : `STATE_F) : `STATE_D;
        `STATE_E: next_state = `STATE_E;
        `STATE_F: next_state = `STATE_F;
        default: next_state = `STATE_A;
    endcase
end

endmodule
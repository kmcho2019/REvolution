`define STATE_A 0
`define STATE_B 1

module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg current_state, next_state;

always @(*) begin
    case(current_state)
        `STATE_B: next_state = (in == 1'b1) ? `STATE_B : `STATE_A;
        `STATE_A: next_state = (in == 1'b1) ? `STATE_A : `STATE_B;
        default: next_state = `STATE_B;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= `STATE_B;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        `STATE_B: out = 1'b1;
        `STATE_A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

endmodule
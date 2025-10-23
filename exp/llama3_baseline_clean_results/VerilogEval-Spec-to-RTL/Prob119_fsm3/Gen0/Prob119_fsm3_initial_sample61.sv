`define STATE_A 2'b00
`define STATE_B 2'b01
`define STATE_C 2'b10
`define STATE_D 2'b11

module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `STATE_A;
    end else begin
        case (state)
            `STATE_A: next_state = in ? `STATE_B : `STATE_A;
            `STATE_B: next_state = in ? `STATE_B : `STATE_C;
            `STATE_C: next_state = in ? `STATE_D : `STATE_A;
            `STATE_D: next_state = in ? `STATE_B : `STATE_C;
            default: next_state = `STATE_A;
        endcase
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        `STATE_A: out = 1'b0;
        `STATE_B: out = 1'b0;
        `STATE_C: out = 1'b0;
        `STATE_D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule
`define STATE_B 2'b00
`define STATE_A 2'b01

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case (state)
        `STATE_B: begin
            if (!in)
                next_state = `STATE_A;
            else
                next_state = `STATE_B;
        end
        `STATE_A: begin
            if (!in)
                next_state = `STATE_B;
            else
                next_state = `STATE_A;
        end
        default: next_state = `STATE_B;
    endcase
end

always @(posedge clk) begin
    if (reset)
        state <= `STATE_B;
    else
        state <= next_state;
end

always @(*) begin
    case (state)
        `STATE_B: out = 1'b1;
        `STATE_A: out = 1'b0;
        default: out = 1'b1;
    endcase
end

endmodule
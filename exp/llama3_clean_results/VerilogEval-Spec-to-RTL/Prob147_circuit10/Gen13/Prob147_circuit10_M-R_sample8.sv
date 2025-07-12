module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg [1:0] state_reg;
assign state = state_reg[0];

always @(posedge clk) begin
    case (state_reg)
        2'b00: if (!a && b) state_reg <= 2'b01;
                else if (a && b) state_reg <= 2'b10;
                else state_reg <= 2'b00;
        2'b01: if (a && b) state_reg <= 2'b10;
                else if (!a &&!b) state_reg <= 2'b00;
                else state_reg <= 2'b01;
        2'b10: if (!a &&!b) state_reg <= 2'b00;
                else state_reg <= 2'b10;
        default: state_reg <= 2'b00;
    endcase
end

assign q = (a && state_reg[0]) || (!a && b);

initial state_reg = 2'b00;

endmodule
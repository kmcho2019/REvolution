module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    case ({a, b})
        2'b00: state <= 1'b1;
        2'b11: state <= 1'b0;
        default: state <= state;
    endcase
end

always @(*) begin
    q = state? 1'b1 : b;
end

endmodule
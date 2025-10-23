module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    case({a, b})
        2'b00: state <= state;
        2'b01: state <= state;
        2'b10: state <= 1'b1;
        2'b11: state <= 1'b0;
        default: state <= 1'b0;
    endcase
end

assign q = (state == 1'b1) || (~a && b);

endmodule
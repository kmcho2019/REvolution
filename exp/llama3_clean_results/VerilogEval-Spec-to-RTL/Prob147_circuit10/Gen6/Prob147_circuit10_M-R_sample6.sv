module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    case ({a, b})
        2'b01: state <= 1'b1;
        2'b11: state <= 1'b0;
        default: state <= state;
    endcase
end

assign q = (state == 1'b0 && a == 1'b0 && b == 1'b1) ||
           (state == 1'b1 && ((a == 1'b1 && b == 1'b0) || (a == 1'b1 && b == 1'b1) || (a == 1'b0 && b == 1'b1)));

endmodule
module TopModule (
    input clk,
    input a,
    output reg q
);

reg state;

always @(posedge clk) begin
    case (state)
        1'b0: state <= a ? 1'b1 : 1'b0;
        1'b1: state <= a ? 1'b1 : 1'b1;
        default: state <= 1'b0;
    endcase
end

always @(*) begin
    q = ~state;
end

endmodule
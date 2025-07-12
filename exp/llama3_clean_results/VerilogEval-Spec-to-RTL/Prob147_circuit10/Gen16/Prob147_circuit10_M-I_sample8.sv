module TopModule(
    input  clk,
    input  a,
    input  b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    case ({a, b})
        2'b11: state <= ~state;
        2'b01: state <= 1'b1;
        default: state <= state;
    endcase
end

always @(*) begin
    q = (state || (!a && b));
end

initial begin
    state = 1'b0;
    q = 1'b0;
end

endmodule
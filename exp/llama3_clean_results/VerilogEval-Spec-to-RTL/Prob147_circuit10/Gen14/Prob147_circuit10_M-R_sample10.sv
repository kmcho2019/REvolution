module TopModule(
    input  clk,
    input  a,
    input  b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    case({a, b})
        2'b00: state <= 0;
        2'b01: state <= 0;
        2'b10: state <= 1;
        2'b11: state <= ~state;
    endcase
end

assign q = (~a && b) || state;

initial begin
    state = 0;
    q = 0;
end

endmodule
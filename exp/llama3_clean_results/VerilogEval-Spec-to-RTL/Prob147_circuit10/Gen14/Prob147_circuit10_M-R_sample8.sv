module TopModule(
    input  clk,
    input  a,
    input  b,
    output reg q,
    output reg state
);

reg next_state;

always @(*) begin
    case ({a, b})
        2'b00: next_state = 0;
        2'b01: next_state = 0;
        2'b10: next_state = 1;
        2'b11: next_state = ~state;
    endcase
    q = (state && a) || (!a && b);
end

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 0;
    q = 0;
end

endmodule
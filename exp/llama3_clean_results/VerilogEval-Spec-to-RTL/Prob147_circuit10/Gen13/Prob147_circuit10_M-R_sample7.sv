module TopModule(
    input  clk,
    input  a,
    input  b,
    output reg q,
    output reg state
);

reg next_state;

always @(posedge clk) begin
    state <= next_state;
end

always @(*) begin
    case ({a, b})
        2'b00: next_state = 0;
        2'b01: next_state = 0;
        2'b10: next_state = 1;
        2'b11: next_state = ~state;
    endcase
    
    case ({state, a, b})
        3'b000: q = 0;
        3'b001: q = 1;
        3'b010: q = 1;
        3'b011: q = 0;
        3'b100: q = 1;
        3'b101: q = 0;
        3'b110: q = 0;
        3'b111: q = 1;
    endcase
end

initial begin
    state = 0;
    q = 0;
end

endmodule
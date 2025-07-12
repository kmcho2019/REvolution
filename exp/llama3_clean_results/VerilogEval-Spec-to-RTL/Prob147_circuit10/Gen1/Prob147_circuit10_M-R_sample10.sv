module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    case({a, b})
        2'b00: state <= !state;
        2'b01: state <= state;
        2'b10: state <= state;
        2'b11: state <= !state;
    endcase
end

assign q = (state && (a || b)) || (!state && (!a && b));

endmodule
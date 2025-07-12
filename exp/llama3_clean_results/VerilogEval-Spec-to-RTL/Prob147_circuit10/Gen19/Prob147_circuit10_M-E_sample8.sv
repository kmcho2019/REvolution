module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    case ({a, b})
        2'b00: state <= 1'b0;
        2'b01: state <= 1'b1;
        2'b10: state <= 1'b0;
        2'b11: state <= ~state;
    endcase
end

assign q = (a && ~b) || state;

endmodule
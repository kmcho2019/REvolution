module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;

always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else begin
        case (state)
            2'b00: begin
                if (r[0]) state <= 2'b01;
                else if (r[1]) state <= 2'b10;
                else state <= 2'b00;
            end
            2'b01: state <= r[0] ? 2'b01 : 2'b00;
            2'b10: state <= r[1] ? 2'b10 : 2'b00;
            default: state <= 2'b00;
        endcase
    end
end

assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (~r[0] && ~r[1] && r[2]);

endmodule